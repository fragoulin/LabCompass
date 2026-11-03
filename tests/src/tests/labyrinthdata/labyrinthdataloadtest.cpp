#include "labyrinthdataloadtest.h"
#include "model/labyrinthdata.h"

LabyrinthDataLoadTest::LabyrinthDataLoadTest(QObject* parent)
    : QObject(parent)
{
}

void LabyrinthDataLoadTest::test_data()
{
    QTest::addColumn<QString>("fileName");

    QTest::newRow("2018-01-09 Normal") << "2018-01-09_normal.json";
    QTest::newRow("2018-01-09 Cruel") << "2018-01-09_cruel.json";
    QTest::newRow("2018-01-09 Merciless") << "2018-01-09_merciless.json";
    QTest::newRow("2018-01-09 Uber") << "2018-01-09_uber.json";
    QTest::newRow("2018-01-10 Normal") << "2018-01-10_normal.json";
    QTest::newRow("2018-01-10 Cruel") << "2018-01-10_cruel.json";
    QTest::newRow("2018-01-10 Merciless") << "2018-01-10_merciless.json";
    QTest::newRow("2018-01-10 Uber") << "2018-01-10_uber.json";
    QTest::newRow("2026-03-14 Cruel") << "2026-03-14_cruel.json"; // Expect failure because of missing exit in basilica halls
}

void LabyrinthDataLoadTest::test()
{
    QFETCH(QString, fileName);
    LabyrinthData data;
    bool result = data.loadFromFile(QDir("data").filePath(fileName));
    if ("2026-03-14_cruel.json" == fileName) {
        QCOMPARE(false, result);
    } else {
        QVERIFY(result);
    }
}
