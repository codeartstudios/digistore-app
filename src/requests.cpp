#include "requests.h"

Requests::Requests(QObject *parent)
    : QObject{parent},
    netman(std::make_unique<QNetworkAccessManager>(this)),
    m_baseUrl(""),
    m_path(""),
    m_method("GET"),
    m_token(""),
    m_headers(QVariantMap()),
    m_body(QVariantMap()),
    m_query(QVariantMap()),
    m_running(false)  {}

QUrl Requests::buildUrl(const QString &_path) {
    QUrl url(m_baseUrl);

    if (!url.path().endsWith("/")) {
        url.setPath(url.path() + "/");
    }

    if(_path.startsWith("/"))
        url.setPath(url.path() + _path.mid(1));
    else
        url.setPath(url.path() + _path);

    return url;
}

QVariantMap Requests::send()
{
    if(m_method.isEmpty())
    {
        QVariantMap e, d;
        e["status"] = 0;
        e["message"] = QString("Request method is not defined");
        d["data"] = e;
        d["status"] = 0;
        d["message"] = QString("Request method is not defined");
        emit error(d);

        logRequest("?", m_path, 0, d["message"].toString());

        return d;
    }

    m_running=true;
    emit runningChanged();

    // Build path URL from the base URL and the route
    QUrl url = buildUrl(m_path);

    // If there are query parameters, pass them into the URL
    if( !m_query.isEmpty() ) {
        QUrlQuery q1;

        foreach( const auto& key, m_query.keys() ) {
            QString value = m_query.value(key).toString();
            q1.addQueryItem(key, value);
        }

        url.setQuery(q1);
    }

    // Create request object
    QNetworkRequest request;
    request.setUrl(url);

    // Add user headers to the request
    if(!m_headers.isEmpty()) {
        foreach(const auto &key, m_headers.keys()) {
            request.setRawHeader(key.toUtf8(), m_headers.value(key).toByteArray());
        }
    }

    // Add authorization header, assuming by default Bearer tokens
    request.setRawHeader("Authorization", QString("Bearer %1").arg(m_token).toUtf8());

    QNetworkReply* reply;
    QJsonDocument doc = QJsonDocument::fromVariant(m_body);

    // If we have files to upload, lets handle it in the multipart
    if ( !m_files.isEmpty() &&
        (m_method == "POST" ||
         m_method == "PUT" ||
         m_method == "PATCH" )
        ) {
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

        for(const auto& key : m_body.keys()) {
            QHttpPart jsonPart;
            jsonPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                               QVariant(QString("form-data; name=\"%1\"").arg(key)));

            // auto ba = convertJsonValueToByteArray(bodyJson.value(key));
            jsonPart.setBody(m_body.value(key).toByteArray());
            multiPart->append(jsonPart);
        }

        // Add files to multipart
        foreach ( const auto& key, m_files.keys() ) {
            // TODO check on multiple file issue

            QFile* file = new QFile(m_files.value(key).toString());
            QString fileName = QFileInfo(file->fileName()).fileName();

            if(!file->exists()) {
                QVariantMap e, d;
                e["status"] = 0;
                e["message"] = QString("File '%1' does not exist").arg(fileName);
                d["data"] = e;
                d["status"] = 0;
                d["message"] = QString("File '%1' does not exist").arg(fileName);

                m_running=false;
                emit runningChanged();
                emit error(d);
                logRequest(m_method, request.url().toString(), 0, d["message"].toString());
                return d;
            }

            if (!file->open(QIODevice::ReadOnly)) {
                QVariantMap d, e;
                e["status"] = 0;
                e["message"] = QString("Could not open '%1' for reading").arg(fileName);
                d["data"] = e;
                d["status"] = 0;
                d["message"] = QString("Could not open '%1' for reading").arg(fileName);

                m_running=false;
                emit runningChanged();
                emit error(d);
                logRequest(m_method, request.url().toString(), 0, d["message"].toString());
                return d;
            }

            QMimeDatabase mimeDatabase;
            QMimeType mimeType = mimeDatabase.mimeTypeForFile(file->fileName());
            QString mimeTypeName = mimeType.name(); // This holds the MIME type (e.g., "image/jpeg")

            QHttpPart filePart;
            filePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant(mimeTypeName));
            filePart.setHeader(QNetworkRequest::ContentDispositionHeader,
                               QVariant(QString("form-data; name=\"%1\"; filename=\"%2\"").arg(key, fileName)));
            filePart.setBodyDevice(file);
            file->setParent(multiPart); // We set the parent to ensure file is deleted with multiPart
            multiPart->append(filePart);
        }

        if (m_method == "POST") {
            reply = netman->post(request, multiPart);
        }

        else if (m_method == "PUT") {
            reply = netman->put(request, multiPart);
        }

        else {
            reply = netman->sendCustomRequest(request, "PATCH", multiPart);
        }

        multiPart->setParent(reply); // Ensure multiPart is deleted with reply
    }

    else {
        request.setRawHeader("Content-Type", "application/json");

        if(m_method == "GET") {
            reply = netman->get(request);
        }

        else if(m_method == "POST") {
            reply = netman->post(request, doc.toJson());
        }

        else if(m_method == "PATCH" ) {
            reply = netman->sendCustomRequest(request, "PATCH", doc.toJson());
        }

        else if(m_method == "PUT") {
            reply = netman->put(request, doc.toJson());
        }

        else if(m_method == "DELETE") {
            reply = netman->deleteResource(request);
        }

        else {
            QVariantMap d, e;
            e["status"] = 0;
            e["message"] = QString("Unhandled method '%1'").arg(m_method);
            d["data"] = e;
            d["status"] = 0;
            d["message"] = QString("Unhandled method '%1'").arg(m_method);

            m_running=false;
            emit runningChanged();
            emit error(d);
            logRequest(m_method, request.url().toString(), 0, d["message"].toString());
            return d;
        }
    }

    QEventLoop wait_loop;
    connect(reply, &QNetworkReply::finished, &wait_loop, &QEventLoop::quit);
    wait_loop.exec();

    int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QJsonDocument resJsonDoc = QJsonDocument::fromJson(reply->readAll());

    QJsonObject responseObject;
    responseObject.insert("status", statusCode);

    if( reply->error() != QNetworkReply::NoError ) {
        responseObject.insert("error", reply->errorString());
    }

    // Add any data to response
    responseObject.insert("data", resJsonDoc.object());

    if( statusCode >= 400 || statusCode < 200 ) {
        auto err = responseObject.toVariantMap();
        emit error(err);
        qDebug() << responseObject;
        QString msg = err["message"].toString() != "" ? err["message"].toString() :
                          err["error"].toString() != "" ? err["error"].toString() :
                          "Something went wrong!";
        logRequest(m_method, request.url().toString(), statusCode, msg);
    } else {
        emit success(responseObject.toVariantMap());
        logRequest(m_method, request.url().toString(), statusCode);
    }

    m_running=false;
    emit runningChanged();
    return responseObject.toVariantMap();
}

bool Requests::abort()
{
    // TODO implement request abort
    return true;
}

void Requests::clear()
{
    // m_path.clear();
    // m_method="GET";
    m_headers.clear();
    m_body.clear();
    m_files.clear();
    m_query.clear();
    abort();

    // emit pathChanged();
    // emit methodChanged();
    emit headersChanged();
    emit bodyChanged();
    emit filesChanged();
    emit queryChanged();
}

void Requests::logRequest(const QString &method, const QString &endpoint, const int &statusCode, const QString& msg)
{
    auto pad = [&](QString val, int width=-1) -> QString {
        if(width == -1 || val.size() >= width) return val;

        for(int i=0; i<(width - val.size()); i++) {
            val += " ";
        }

        return val;
    };

    qDebug() << QString("/%1 %2 %3")
                    .arg(pad(method, 6),
                         pad(QString::number(statusCode), 4),
                         endpoint);

    if(msg!="")
        qDebug() << "            > " << msg;
}

QByteArray Requests::convertJsonValueToByteArray(const QJsonValue &value) {
    QByteArray byteArray;

    switch (value.type()) {
    case QJsonValue::Bool:
        byteArray = value.toBool() ? "true" : "false";
        break;
    case QJsonValue::Double:
        byteArray = QByteArray::number(value.toDouble());
        break;
    case QJsonValue::String:
        byteArray = value.toString().toUtf8();
        break;
    case QJsonValue::Array: {
        QJsonDocument doc(value.toArray());
        byteArray = doc.toJson(QJsonDocument::Compact);
        break;
    }
    case QJsonValue::Object: {
        QJsonDocument doc(value.toObject());
        byteArray = doc.toJson(QJsonDocument::Compact);
        break;
    }
    case QJsonValue::Null:
    case QJsonValue::Undefined:
        byteArray = "null";
        break;
    }

    return byteArray;
}

QJsonValue Requests::variantToJson(const QVariant &variant) {
    if (variant.typeId() == QMetaType::QVariantMap) {
        QJsonObject obj;
        auto map = variant.toMap();

        foreach (const auto& key, map.keys()) {
            obj.insert(key, variantToJson(map.value(key)));
        }

        return obj;
    }

    else if (variant.typeId() == QMetaType::QVariantList) {
        QJsonArray array;
        for (const QVariant &value : variant.toList()) {
            array.append(variantToJson(value));
        }
        return array;
    }

    else {
        // For simple types, directly convert
        return QJsonValue::fromVariant(variant);
    }
}
