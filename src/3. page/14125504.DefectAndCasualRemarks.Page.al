page 14125504 "Defect And Casual Remarks"
{
    AutoSplitKey = true;
    CardPageID = "Service DC Card";
    PageType = List;
    SourceTable = Table14125606;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Service Order No."; "Service Order No.")
                {
                    Editable = false;
                }
                field(Code; Code)
                {
                }
                field("Defect Code"; "Defect Code")
                {
                }
                field("Defect Value"; "Defect Value")
                {
                    Editable = false;
                }
                field("Casual Code 1"; "Casual Code 1")
                {
                }
                field("Casual Code 2"; "Casual Code 2")
                {
                }
                field("Casual Code 3"; "Casual Code 3")
                {
                }
                field("Casual Code 4"; "Casual Code 4")
                {
                }
                field("Casual Code 5"; "Casual Code 5")
                {
                }
                field("Casual Code 6"; "Casual Code 6")
                {
                }
                field("Casual Code 7"; "Casual Code 7")
                {
                }
                field("RV RR Code"; "RV RR Code")
                {
                    Editable = false;
                }
                field("RV RR Justification"; "RV RR Justification")
                {
                    Caption = 'RV RR Justification';
                }
                field("Action Taken"; "Action Taken")
                {
                }
                field("Customer Verbatim"; "Customer Verbatim")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IF ServCode <> '' THEN BEGIN
            "Service Order No." := ServCode;
            Type := Type::Order;
            "Is Complain" := TRUE;
            VIN := VIN_;
        END;
    end;

    trigger OnOpenPage()
    begin
        IF ServCode <> '' THEN BEGIN
            SETRANGE("Service Order No.", ServCode);
            SETRANGE("Past Invoice", FALSE);
            SETRANGE("Is Complain", TRUE);
        END ELSE
            SETRANGE("Is Complain", TRUE);
    end;

    var
        ServCode: Code[20];
        VIN_: Code[20];

    [Scope('Internal')]
    procedure insertHeaderNo(_servCode: Code[20]; _VIN: Code[20])
    begin
        ServCode := _servCode;
        VIN_ := _VIN;
    end;
}

