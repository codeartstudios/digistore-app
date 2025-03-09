#ifndef SINGLEINSTANCEGUARD_H
#define SINGLEINSTANCEGUARD_H

#include <QObject>
#include <QSharedMemory>
#include <QSystemSemaphore>
#include <QCryptographicHash>

class SingleInstanceGuard : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(SingleInstanceGuard);

public:
    explicit SingleInstanceGuard(const QString& key, QObject* parent = nullptr);
    ~SingleInstanceGuard();

    bool tryToRun();

private:
    bool isAnotherRunning();
    void release();
    static QString hash(const QString& key, const QString& salt);

    const QString m_key;
    const QString m_memLockKey;
    const QString m_sharedMemKey;

    QSharedMemory sharedMemory;
    QSystemSemaphore memoryLock;
};

#endif // SINGLEINSTANCEGUARD_H
