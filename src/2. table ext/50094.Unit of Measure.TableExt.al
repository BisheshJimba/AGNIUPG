tableextension 50094 tableextension50094 extends "Unit of Measure"
{
    // 2012.08.29 EDMS P8
    //   * Added fields: "Minutes Per UoM"
    fields
    {
        field(25006000; "Minutes Per UoM"; Decimal)
        {
            Caption = 'Minutes Per UoM';
        }
        field(25006900; "Daimler Measure Code"; Code[10])
        {
            Caption = 'Daimler Measure Code';
        }
    }
}

