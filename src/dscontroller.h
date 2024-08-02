#ifndef DSCONTROLLER_H
#define DSCONTROLLER_H

#include <QObject>
#include <QGuiApplication>
#include <QSettings>
#include <QVariantMap>
#include <QJsonDocument>
#include <QFile>
#include <memory>

class DsController : public QObject
{
    Q_OBJECT
public:
    explicit DsController(QObject *parent = nullptr);

    Q_PROPERTY(QString encryptionKey MEMBER m_encryptionKey NOTIFY encryptionKeyChanged FINAL)
    Q_PROPERTY(QString encryptionSalt MEMBER m_encryptionSalt NOTIFY encryptionSaltChanged FINAL)

signals:
    void encryptionKeyChanged();
    void encryptionSaltChanged();

private:
    std::shared_ptr<QSettings> settings;
    QString m_encryptionKey;
    QString m_encryptionSalt;
};

#endif // DSCONTROLLER_H
