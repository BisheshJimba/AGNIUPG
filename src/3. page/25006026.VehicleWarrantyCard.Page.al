page 25006026 "Vehicle Warranty Card"
{
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added fields new

    Caption = 'Vehicle Warranty Card';
    PageType = Document;
    SourceTable = Table25006036;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
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
                    Visible = VF25006800Visible;
                }
                field("Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = VF25006801Visible;
                }
                field("Variable Field 25006802"; "Variable Field 25006802")
                {
                    Visible = VF25006802Visible;
                }
                field("Variable Field 25006803"; "Variable Field 25006803")
                {
                    Visible = VF25006803Visible;
                }
                field("Variable Field 25006804"; "Variable Field 25006804")
                {
                    Visible = VF25006804Visible;
                }
                field("Variable Field 25006805"; "Variable Field 25006805")
                {
                    Visible = VF25006805Visible;
                }
                field("Variable Field 25006806"; "Variable Field 25006806")
                {
                    Visible = VF25006806Visible;
                }
                field("Variable Field 25006807"; "Variable Field 25006807")
                {
                    Visible = VF25006807Visible;
                }
                field("Ending Date"; "Ending Date")
                {
                    Importance = Additional;
                }
                field(Description; Description)
                {
                    Importance = Additional;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        [InDataSet]
        VF25006800Visible: Boolean;
        [InDataSet]
        VF25006801Visible: Boolean;
        [InDataSet]
        VF25006802Visible: Boolean;
        [InDataSet]
        VF25006803Visible: Boolean;
        [InDataSet]
        VF25006804Visible: Boolean;
        [InDataSet]
        VF25006805Visible: Boolean;
        [InDataSet]
        VF25006806Visible: Boolean;
        [InDataSet]
        VF25006807Visible: Boolean;
        [InDataSet]
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        //Variable Fields
        VF25006800Visible := IsVFActive(FIELDNO("Variable Field 25006800"));
        VF25006801Visible := IsVFActive(FIELDNO("Variable Field 25006801"));
        VF25006802Visible := IsVFActive(FIELDNO("Variable Field 25006802"));
        VF25006803Visible := IsVFActive(FIELDNO("Variable Field 25006803"));
        VF25006804Visible := IsVFActive(FIELDNO("Variable Field 25006804"));
        VF25006805Visible := IsVFActive(FIELDNO("Variable Field 25006805"));
        VF25006806Visible := IsVFActive(FIELDNO("Variable Field 25006806"));
        VF25006807Visible := IsVFActive(FIELDNO("Variable Field 25006807"));
        VFRun1Visible := IsVFActive(FIELDNO("Kilometrage Limit"));
        VFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        VFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    [Scope('Internal')]
    procedure SetRange(VehSerialNo: Code[20])
    begin
        SETRANGE("Vehicle Serial No.", VehSerialNo);
    end;
}

