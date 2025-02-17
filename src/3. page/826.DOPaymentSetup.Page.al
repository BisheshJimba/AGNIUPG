page 826 "DO Payment Setup"
{
    Caption = 'Microsoft Dynamics ERP Payment Services Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "DO Payment Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Authorization Required"; Rec."Authorization Required")
                {
                }
                field("Days Before Authoriz. Expiry"; Rec."Days Before Authoriz. Expiry")
                {
                }
            }
            group("Additional Charges")
            {
                Caption = 'Additional Charges';
                field("Charge Type"; Rec."Charge Type")
                {

                    trigger OnValidate()
                    begin
                        MCAIsEnabled := Rec."Charge Type" = Rec."Charge Type"::Percent;
                    end;
                }
                field("Charge Value"; Rec."Charge Value")
                {
                }
                field("Max. Charge Amount (LCY)"; Rec."Max. Charge Amount (LCY)")
                {
                    Enabled = MCAIsEnabled;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Credit Card Nos."; Rec."Credit Card Nos.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        MCAIsEnabled := Rec."Charge Type" = Rec."Charge Type"::Percent;
    end;

    trigger OnInit()
    begin
        MCAIsEnabled := TRUE;
    end;

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;

    var
        [InDataSet]
        MCAIsEnabled: Boolean;
}

