page 25006027 "Vehicle Warranty List"
{
    Caption = 'Vehicle Warranty List';
    CardPageID = "Vehicle Warranty Card";
    PageType = List;
    SourceTable = Table25006036;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field("Warranty Type Code"; "Warranty Type Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Term Date Formula"; "Term Date Formula")
                {
                }
                field("Kilometrage Limit"; "Kilometrage Limit")
                {
                    Visible = VFRun1Visible;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = VFRun2Visible;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = VFRun3Visible;
                }
                field(Status; Status)
                {
                }
                field("Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = DMSVariableField25006800Visibl;
                }
                field("Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = DMSVariableField25006801Visibl;
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
                field("Variable Field 25006806"; "Variable Field 25006806")
                {
                    Visible = DMSVariableField25006806Visibl;
                }
                field("Variable Field 25006807"; "Variable Field 25006807")
                {
                    Visible = DMSVariableField25006807Visibl;
                }
                field("Variable Field 25006808"; "Variable Field 25006808")
                {
                    Visible = DMSVariableField25006808Visibl;
                }
                field("Variable Field 25006809"; "Variable Field 25006809")
                {
                    Visible = DMSVariableField25006809Visibl;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Warranty)
            {
                Caption = 'Warranty';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F5';

                    trigger OnAction()
                    begin
                        PAGE.RUN(PAGE::"Vehicle Warranty Card", Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        fSetVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        fHideVariableFields;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fHideVariableFields;
        OnAfterGetCurrRecord;
    end;

    var
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
        [InDataSet]
        DMSVariableField25006806Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006807Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006808Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006809Visibl: Boolean;
        [InDataSet]
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;

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
        DMSVariableField25006806Visibl := IsVFActive(FIELDNO("Variable Field 25006806"));
        DMSVariableField25006807Visibl := IsVFActive(FIELDNO("Variable Field 25006807"));
        DMSVariableField25006808Visibl := IsVFActive(FIELDNO("Variable Field 25006808"));
        DMSVariableField25006809Visibl := IsVFActive(FIELDNO("Variable Field 25006809"));
        VFRun1Visible := IsVFActive(FIELDNO("Kilometrage Limit"));
        VFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        VFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    [Scope('Internal')]
    procedure fHideVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := FALSE;
        DMSVariableField25006801Visibl := FALSE;
        DMSVariableField25006802Visibl := FALSE;
        DMSVariableField25006803Visibl := FALSE;
        DMSVariableField25006804Visibl := FALSE;
        DMSVariableField25006805Visibl := FALSE;
        DMSVariableField25006806Visibl := FALSE;
        DMSVariableField25006807Visibl := FALSE;
        DMSVariableField25006808Visibl := FALSE;
        DMSVariableField25006809Visibl := FALSE;
        VFRun1Visible := FALSE;
        VFRun2Visible := FALSE;
        VFRun3Visible := FALSE;
    end;

    [Scope('Internal')]
    procedure SetRange(VehSerialNo: Code[20])
    begin
        SETRANGE("Vehicle Serial No.", VehSerialNo);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}

