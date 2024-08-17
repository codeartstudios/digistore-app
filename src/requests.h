#ifndef REQUESTS_H
#define REQUESTS_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QHttpPart>
#include <QHttpMultiPart>
#include <QNetworkAccessManager>
#include <QFile>
#include <QFileInfo>
#include <QMimeDatabase>
#include <QMimeType>
#include <QEventLoop>

class Requests : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString baseUrl MEMBER m_baseUrl NOTIFY baseUrlChanged FINAL)

    explicit Requests(QObject *parent = nullptr);

    QUrl buildUrl(const QString& path);

    QJsonObject send(const QString& path, const QJsonObject params);

signals:
    void baseUrlChanged();

private:
    // Functions
    QByteArray convertJsonValueToByteArray(const QJsonValue &value);


    // Variables
    QString m_baseUrl;
};

#endif // REQUESTS_H
