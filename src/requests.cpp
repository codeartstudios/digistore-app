#include "requests.h"

Requests::Requests(QObject *parent)
    : QObject{parent}
{}

QUrl Requests::buildUrl(const QString &path) {
    QUrl url(m_baseUrl);

    if (!url.path().endsWith("/")) {
        url.setPath(url.path() + "/");
    }

    if(path.startsWith("/"))
        url.setPath(url.path() + path.mid(1));
    else
        url.setPath(url.path() + path);

    return url;
}

QJsonObject Requests::send(const QString &path, const QJsonObject params) {
    // Build path URL from the base URL and the route
    QUrl url = buildUrl(path);

    // If there are query parameters, pass them into the URL
    if( params.contains("query") && !params.value("query").isNull() ) {
        QUrlQuery q1;

        for( const auto& key : params.value("query").toObject().keys() ) {
            QString value = params.value("query").toObject().value(key).toString();
            q1.addQueryItem(key, value);
        }

        url.setQuery(q1);
    }

    // Create request object
    QNetworkRequest request;
    request.setUrl(url);
    qDebug() << "\n[Requests] Making a ("
             << params.value("method").toString()
             << ") request to '" << request.url().toString() << "'";

    // If no auth disabled by user
    if( params.contains("headers") &&
        params.value("headers").toObject().contains("auth") &&
        !params.value("headers").toObject().value("auth").toBool()) {}

    // Explicitly pass the auth header unless specified to be ignored
    else {
        // request.setRawHeader("Authorization", "Bearer " + m_authStore->token().toUtf8());
    }

    auto bodyJson = params.value("body").toObject(QJsonObject());
    QStringList textKeys, fileKeys;

    // Extract the keys, into the text and file arrays
    for(const auto& key : bodyJson.keys()) {
        auto obj = bodyJson.value(key).toObject();
        if( obj.value("type").toString("") == "files" ) {
            fileKeys.append(key);
        } else {
            textKeys.append(key);
        }
    }

    // Create Network Access Manager
    std::unique_ptr<QNetworkAccessManager> netman = std::make_unique<QNetworkAccessManager>(this);
    QNetworkReply* reply;
    QJsonDocument doc(bodyJson);

    // If we have files to upload, lets handle it in the multipart
    if ( fileKeys.size() > 0 &&
        (params.value("method").toString() == "POST" ||
         params.value("method").toString() == "PUT" ||
         params.value("method").toString() == "PATCH" )) {
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

        for(const auto& key : textKeys ) {
            QHttpPart jsonPart;
            jsonPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                               QVariant(QString("form-data; name=\"%1\"").arg(key)));

            auto ba = convertJsonValueToByteArray(bodyJson.value(key));
            jsonPart.setBody(ba);
            multiPart->append(jsonPart);
        }

        // Add files to multipart
        for ( const auto& key : fileKeys ) {
            auto obj = bodyJson.value(key).toObject();
            auto filesArray = obj.value("files").toArray();

            for( const auto& filePath : filesArray ) {
                QFile* file = new QFile(filePath.toString());
                QString fileName = QFileInfo(file->fileName()).fileName();

                if(!file->exists()) {
                    // throw ClientResponseError("File not found", 0, file->fileName());
                }

                if (!file->open(QIODevice::ReadOnly)) {
                    // QString err = file->errorString();
                    // throw ClientResponseError("Error opening attached file", 0, file->fileName());
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
        }

        if (params.value("method").toString() == "POST") {
            reply = netman->post(request, multiPart);
        }

        else if (params.value("method").toString() == "PUT") {
            reply = netman->put(request, multiPart);
        }

        else {
            reply = netman->sendCustomRequest(request, "PATCH", multiPart);
        }

        multiPart->setParent(reply); // Ensure multiPart is deleted with reply
    }

    else {
        request.setRawHeader("Content-Type", "application/json");

        if(params.value("method").toString() == "GET") {
            reply = netman->get(request);
        }

        else if(params.value("method").toString() == "POST") {
            reply = netman->post(request, doc.toJson());
        }

        else if(params.value("method").toString() == "PATCH" ) {
            reply = netman->sendCustomRequest(request, "PATCH", doc.toJson());
        }

        else if(params.value("method").toString() == "PUT") {
            reply = netman->put(request, doc.toJson());
        }

        else if(params.value("method").toString() == "DELETE") {
            reply = netman->deleteResource(request);
        }

        else {
            // throw ClientResponseError("Unhandled Method", 404);
            qDebug() << "Unhandled: " << params.value("method").toString();
        }
    }

    QEventLoop wait_loop;
    connect(reply, &QNetworkReply::finished, &wait_loop, &QEventLoop::quit);
    wait_loop.exec();

    int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QJsonDocument resJsonDoc = QJsonDocument::fromJson(reply->readAll());

    QJsonObject responseObject;
    responseObject.insert("statusCode", statusCode);
    responseObject.insert("data", resJsonDoc.object());

    if( reply->error() != QNetworkReply::NoError ) {
        responseObject.insert("error", reply->errorString());
    }

    if( statusCode >= 400 || statusCode < 200 ) {
        qDebug() << resJsonDoc;
        QString msg = resJsonDoc.object()["message"].toString();
        // throw ClientResponseError(msg, statusCode, request.url().toString());
    }

    return responseObject;
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
