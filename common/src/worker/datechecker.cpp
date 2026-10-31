#include "datechecker.h"

DateChecker::DateChecker(ApplicationModel* applicationModel, QObject* parent)
    : QObject(parent)
{
    this->model = applicationModel;

    timer.setInterval(1000);
    timer.setSingleShot(false);
    timer.start();
    connect(&timer, &QTimer::timeout,
        this, &DateChecker::work);

    work();
}

void DateChecker::work()
{
    model->update_currentUtcDate(QDateTime::currentDateTimeUtc().date());
}
