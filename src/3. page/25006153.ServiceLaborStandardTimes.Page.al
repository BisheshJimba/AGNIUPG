page 25006153 "Service Labor Standard Times"
{
    AutoSplitKey = true;
    Caption = 'Service Labor Standard Times';
    DataCaptionFields = "Labor No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006122;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = DMSVariableField25006800Visibl;
                }
                field("Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = DMSVariableField25006801Visibl;
                }
                field("Labor No."; "Labor No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Description 3"; "Description 3")
                {
                }
                field("Standard Time (Hours)"; "Standard Time (Hours)")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Prod. Year From"; "Prod. Year From")
                {
                }
                field("Prod. Year To"; "Prod. Year To")
                {
                }
                field("Variable Field 25006802"; "Variable Field 25006802")
                {
                    Visible = DMSVariableField25006802Visibl;
                }
                field("Variable Field 25006803"; "Variable Field 25006803")
                {
                    Visible = DMSVariableField25006803Visibl;
                }
                field("Variable Field 25006804"; "Variable Field 25006804")
                {
                    Visible = DMSVariableField25006804Visibl;
                }
                field("Variable Field 25006805"; "Variable Field 25006805")
                {
                    Visible = DMSVariableField25006805Visibl;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        DMSVariableField25006805Visibl := TRUE;
        DMSVariableField25006804Visibl := TRUE;
        DMSVariableField25006803Visibl := TRUE;
        DMSVariableField25006802Visibl := TRUE;
        DMSVariableField25006801Visibl := TRUE;
        DMSVariableField25006800Visibl := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        fGetFilters;
        fSetVariableFields
    end;

    var
        txtFilter: array[12] of Text[250];
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006802Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006803Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006804Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006805Visibl: Boolean;

    [Scope('Internal')]
    procedure fGetFilters()
    begin
        txtFilter[1] := GETFILTER("Make Code");
        txtFilter[2] := GETFILTER("Model Code");
        txtFilter[3] := GETFILTER("Prod. Year From");
        txtFilter[4] := GETFILTER("Prod. Year To");
    end;

    [Scope('Internal')]
    procedure fSetLookFilter(intFilterNo: Integer)
    var
        recMake: Record "25006000";
        recModel: Record "25006001";
    begin
        CASE intFilterNo OF
            1:
                IF PAGE.RUNMODAL(PAGE::"Make List", recMake) = ACTION::LookupOK THEN
                    txtFilter[1] := recMake.Code;

            2:
                IF PAGE.RUNMODAL(PAGE::"Model List", recModel) = ACTION::LookupOK THEN
                    txtFilter[2] := recModel.Code;
        END;

        fSetValdateFilter(intFilterNo);
    end;

    [Scope('Internal')]
    procedure fSetValdateFilter(intFilterNo: Integer)
    var
        recMake: Record "25006000";
        recModel: Record "25006001";
    begin
        CASE intFilterNo OF
            1:
                SETFILTER("Make Code", txtFilter[intFilterNo]);
            2:
                SETFILTER("Model Code", txtFilter[intFilterNo]);
            3:
                SETFILTER("Prod. Year From", txtFilter[intFilterNo]);
            4:
                SETFILTER("Prod. Year To", txtFilter[intFilterNo]);
        END;

        CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := IsVFActive(FIELDNO("Variable Field 25006800"));
        DMSVariableField25006801Visibl := IsVFActive(FIELDNO("Variable Field 25006801"));
        DMSVariableField25006802Visibl := IsVFActive(FIELDNO("Variable Field 25006802"));
        DMSVariableField25006803Visibl := IsVFActive(FIELDNO("Variable Field 25006803"));
        DMSVariableField25006804Visibl := IsVFActive(FIELDNO("Variable Field 25006804"));
        DMSVariableField25006805Visibl := IsVFActive(FIELDNO("Variable Field 25006805"));
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}

