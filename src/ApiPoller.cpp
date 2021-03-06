#include "ApiPoller.hpp"
#include "lmq_settings.hpp"
#include <string>

#include <QObject>
#include <QDebug>

// ApiPoller Constructor
ApiPoller::ApiPoller() :
  QObject(nullptr)
{
    m_timer = new QTimer();
    m_timer->setInterval(DEFAULT_POLLING_INTERVAL_MS);
    connect(m_timer, &QTimer::timeout, this, &ApiPoller::pollDaemon);
}

// ApiPoller Destructor
ApiPoller::~ApiPoller() {
    delete m_timer;
    m_timer = nullptr;
}

// ApiPoller::setApiEndpoint
void ApiPoller::setApiEndpoint(const QString& endpoint) {
    m_rpcMethod = endpoint.toStdString();
}

// ApiPoller::setIntervalMs
void ApiPoller::setIntervalMs(int intervalMs) {
    m_timer->setInterval(intervalMs);
}

// ApiPoller::startPolling
void ApiPoller::startPolling() {
    m_timer->start();
}

// ApiPoller::stopPolling
void ApiPoller::stopPolling() {
    m_timer->stop();
}

// ApiPoller::pollImmediately
void ApiPoller::pollImmediately() {
    QTimer::singleShot(0, this, &ApiPoller::pollDaemon);
}

// ApiPoller::pollDaemon
void ApiPoller::pollDaemon() {
    if (m_rpcMethod.empty()) {
      qDebug() << "Warning: No endpoint; call ApiPoller::setApiEndpoint() before polling";
      return;
    }
    if(lmq_conn.has_value())
    {
      lmq.request(
        *lmq_conn,
        m_rpcMethod,
        [=](bool success, std::vector<std::string> data)
        {
          if(success and not data.empty())
          {
            emit statusAvailable(QString::fromStdString(data[0]));
          }
        });
    }
}
