tableextension 50416 tableextension50416 extends "Item Budget Name"
{
    fields
    {
        field(8; "Budget Dimension 4 Code"; Code[20])
        {
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                IF "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" THEN BEGIN //MIN 12/6/2019
                    IF Dim.CheckIfDimUsed("Budget Dimension 4 Code", 20, Name, '', "Analysis Area") THEN
                        ERROR(Text000, Dim.GetCheckDimErr);
                    MODIFY;
                END;
            end;
        }
    }
}

