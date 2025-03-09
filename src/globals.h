#ifndef GLOBALS_H
#define GLOBALS_H

#include <QStandardPaths>
#include <QDateTime>
#include <QFile>

class Configurator {
public:
    Configurator() = default;

    static QString logFilePath() {
        return QString("%1/digisto.log").arg(Configurator::appDataDir());
    }

    static QString appDataDir() {
        return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    }


    static void messageHandler(QtMsgType msgType,
                               const QMessageLogContext &context,
                               const QString &msg) {
        Q_UNUSED(context);
        static QString lastMsg;

        if (lastMsg == msg) {
            return;
        }

        lastMsg = msg.trimmed();

        QString dt = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
        QString logMessage("%1 %2 digisto: %3");
        QString msgTypeStr;

        switch (msgType) {
        case QtDebugMsg:    msgTypeStr = "[DBG]"; break;
        case QtInfoMsg:     msgTypeStr = "[INF]"; break;
        case QtWarningMsg:  msgTypeStr = "[WRN]"; break;
        case QtCriticalMsg: msgTypeStr = "[CTL]"; break;
        case QtFatalMsg:    msgTypeStr = "[FTL]"; break;
        default: break;
        }

#ifdef QT_DEBUG
        QTextStream(stdout) << logMessage.arg(dt, msgTypeStr, lastMsg) << Qt::endl;
#else
        QFile logFile(Configurator::logFilePath());
        logFile.open(QIODevice::WriteOnly | QIODevice::Append);

        QTextStream logTextStream(&logFile);
        logTextStream << logMessage.arg(dt, msgTypeStr, lastMsg) << Qt::endl;
        logFile.close();
#endif
    }
};

#endif // GLOBALS_H
