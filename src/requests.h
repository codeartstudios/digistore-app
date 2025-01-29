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
#include <QMetaProperty>


class Requests : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString baseUrl MEMBER m_baseUrl NOTIFY baseUrlChanged FINAL)
    Q_PROPERTY(QString path MEMBER m_path NOTIFY pathChanged FINAL)
    Q_PROPERTY(QString method MEMBER m_method NOTIFY methodChanged FINAL)
    Q_PROPERTY(QString token MEMBER m_token NOTIFY tokenChanged FINAL)
    Q_PROPERTY(QVariantMap headers MEMBER m_headers NOTIFY headersChanged FINAL)
    Q_PROPERTY(QVariantMap body MEMBER m_body NOTIFY bodyChanged FINAL)
    Q_PROPERTY(QVariantMap files MEMBER m_files NOTIFY filesChanged FINAL)
    Q_PROPERTY(QVariantMap query MEMBER m_query NOTIFY queryChanged FINAL)
    Q_PROPERTY(bool running MEMBER m_running NOTIFY runningChanged FINAL)

    explicit Requests(QObject *parent = nullptr);

    // Create a full URL for requests, concatenates the
    // base URL and the endpoint (path)
    QUrl buildUrl(const QString& path);

    // Initiate a request
    Q_INVOKABLE QVariantMap send();

    // Abort the current request
    Q_INVOKABLE bool abort();

    // Clear all parameters except baseUrl
    Q_INVOKABLE void clear();

    void logRequest(const QString& method, const QString& endpoint, const int& statusCode=-1);

signals:
    void baseUrlChanged();      // Server base URL
    void pathChanged();         // Request endpoint
    void methodChanged();       // Request Method [GET/POST/PUT/PATCH/DELETE]
    void headersChanged();      // Request Headers
    void bodyChanged();         // Request Body
    void filesChanged();        // Attached files on the body
    void queryChanged();        // Request Query
    void runningChanged();      // Request Status [Running or not]

    // Signal to be emitted when the request error's out
    void error(const QVariantMap& error);

    // Signal to be emitted once the request completes, no error
    void success(const QVariantMap& response);

    void tokenChanged();

private:
    // Functions
    QByteArray convertJsonValueToByteArray(const QJsonValue &value);
    // Function to recursively convert QVariant to QJsonValue
    QJsonValue variantToJson(const QVariant &variant);
    // Helper to convert QObject* to QJsonObject
    QJsonObject objectToJson(QObject *object);

    // Create Network Access Manager
    std::unique_ptr<QNetworkAccessManager> netman;

    // Variables
    QString m_baseUrl;
    QString m_path;
    QString m_method;
    QVariantMap m_headers;
    QVariantMap m_body;
    QVariantMap m_files;
    QVariantMap m_query;
    bool m_running;
    QString m_token;
};

#endif // REQUESTS_H
