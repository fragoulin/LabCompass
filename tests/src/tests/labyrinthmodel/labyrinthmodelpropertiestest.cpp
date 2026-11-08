#include "labyrinthmodelpropertiestest.h"
#include "model/labyrinthmodel.h"

LabyrinthModelPropertiesTest::LabyrinthModelPropertiesTest(QObject* parent)
    : QObject(parent)
{
}

void LabyrinthModelPropertiesTest::test_data()
{
    QTest::addColumn<QString>("fileName");
    QTest::addColumn<QString>("difficulty");
    QTest::addColumn<QDate>("date");

    QTest::newRow("2018-01-09 Normal") << "2018-01-09_normal.json"
                                       << "Normal" << QDate(2018, 1, 9);
    QTest::newRow("2018-01-09 Cruel") << "2018-01-09_cruel.json"
                                      << "Cruel" << QDate(2018, 1, 9);
    QTest::newRow("2018-01-09 Merciless") << "2018-01-09_merciless.json"
                                          << "Merciless" << QDate(2018, 1, 9);
    QTest::newRow("2018-01-09 Uber") << "2018-01-09_uber.json"
                                     << "Uber" << QDate(2018, 1, 9);
    QTest::newRow("2018-01-10 Normal") << "2018-01-10_normal.json"
                                       << "Normal" << QDate(2018, 1, 10);
    QTest::newRow("2018-01-10 Cruel") << "2018-01-10_cruel.json"
                                      << "Cruel" << QDate(2018, 1, 10);
    QTest::newRow("2018-01-10 Merciless") << "2018-01-10_merciless.json"
                                          << "Merciless" << QDate(2018, 1, 10);
    QTest::newRow("2018-01-10 Uber") << "2018-01-10_uber.json"
                                     << "Uber" << QDate(2018, 1, 10);
    QTest::newRow("2026-03-14 Cruel") << "2026-03-14_cruel.json"
                                      << "Cruel" << QDate(2026, 3, 14);
}

void LabyrinthModelPropertiesTest::test()
{
    QFETCH(QString, fileName);

    LabyrinthData data;
    data.loadFromFile(QDir("data").filePath(fileName));
    LabyrinthModel model;
    model.loadFromData(data);

    QFETCH(QString, difficulty);
    if ("Normal" == difficulty)
        QCOMPARE(model.get_difficulty(), 0);
    else if ("Cruel" == difficulty)
        QCOMPARE(model.get_difficulty(), 1);
    else if ("Merciless" == difficulty)
        QCOMPARE(model.get_difficulty(), 2);
    else if ("Uber" == difficulty)
        QCOMPARE(model.get_difficulty(), 3);

    QFETCH(QDate, date);
    QCOMPARE(model.get_date(), date);
}
