#ifndef TESTDATAAVAILABLETEST_H
#define TESTDATAAVAILABLETEST_H

#include <QTest>

class TestDataAvailableTest : public QObject {
    Q_OBJECT

public:
    explicit TestDataAvailableTest(QObject* parent = nullptr);

private slots:
    void test_data();
    void test();
};

#endif // TESTDATAAVAILABLETEST_H
