page 50051 "Dimension Table Fields"
{
    Caption = 'Dimension Correction Fields';
    DataCaptionExpression = PageCaption;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table2000000041;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                    Caption = 'No.';
                    Editable = false;
                    Lookup = false;
                }
                field("Field Caption"; "Field Caption")
                {
                    Caption = 'Field Caption';
                    DrillDown = false;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //GetRec;
        //TransFromRec;
    end;

    trigger OnAfterGetRecord()
    begin
        //GetRec;
        //TransFromRec;
    end;

    trigger OnInit()
    begin
        "Log DeletionVisible" := TRUE;
        "Log ModificationVisible" := TRUE;
        "Log InsertionVisible" := TRUE;
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        SETRANGE(Class, Class::Normal);
        FILTERGROUP(0);
        PageCaption := FORMAT(TableNo) + ' ' + TableName;
    end;

    var
        ChangeLogSetupField: Record "404";
        CannotChangeColumnErr: Label 'You cannot change this column.';
        LogIns: Boolean;
        LogMod: Boolean;
        LogDel: Boolean;
        InsVisible: Boolean;
        ModVisible: Boolean;
        DelVisible: Boolean;
        [InDataSet]
        "Log InsertionVisible": Boolean;
        [InDataSet]
        "Log ModificationVisible": Boolean;
        [InDataSet]
        "Log DeletionVisible": Boolean;
        PageCaption: Text[250];
}

