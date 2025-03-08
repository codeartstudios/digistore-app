#include "singleinstanceguard.h"

SingleInstanceGuard::SingleInstanceGuard(const QString &key, QObject *parent)
    : QObject(parent),
    m_key(key),
    m_memLockKey(hash(key, "Digisto")),
    m_sharedMemKey(hash(key, "DigistoSingleInstanceKey")),
    sharedMemory(m_sharedMemKey),
    memoryLock(m_memLockKey, 1)
{
    memoryLock.acquire();
    {
        // Fix for *nix: http://habrahabr.ru/post/173281/
        QSharedMemory fix(m_sharedMemKey);
        fix.attach();
    }
    memoryLock.release();
}

SingleInstanceGuard::~SingleInstanceGuard() { release(); }

bool SingleInstanceGuard::isAnotherRunning() {
    if (sharedMemory.isAttached()) {
        return false;
    }
    memoryLock.acquire();
    const bool isRunning = sharedMemory.attach();
    if (isRunning) {
        sharedMemory.detach();
    }
    memoryLock.release();

    return isRunning;
}

bool SingleInstanceGuard::tryToRun() {
    if (isAnotherRunning()) {
        return false;
    }

    memoryLock.acquire();
    const bool result = sharedMemory.create(sizeof(quint64));
    memoryLock.release();

    if (!result) {
        release();
        return false;
    }

    return true;
}

void SingleInstanceGuard::release() {
    memoryLock.acquire();

    if (sharedMemory.isAttached()) {
        sharedMemory.detach();
    }

    memoryLock.release();
}

QString SingleInstanceGuard::hash(const QString &key, const QString &salt) {
    QByteArray hashValue;
    hashValue.append(key.toUtf8());
    hashValue.append(salt.toUtf8());

    return QCryptographicHash::hash(hashValue, QCryptographicHash::Sha1).toHex();
}
