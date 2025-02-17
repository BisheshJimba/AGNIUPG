page 33020217 "Posted Veh. Registration Lines"
{
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Table33020174;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("General Journal Created"; "General Journal Created")
                {
                }
                field("GL Entry Created"; "GL Entry Created")
                {
                    Editable = false;
                }
                field(Skip; Skip)
                {
                }
                field("Serial No."; "Serial No.")
                {
                    Editable = false;
                }
                field("Registration No."; "Registration No.")
                {
                    Editable = false;
                }
                field(VIN; VIN)
                {
                    Editable = false;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("DRP No./ARE1 No."; "DRP No./ARE1 No.")
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Expected Expenses"; "Expected Expenses")
                {
                    Editable = false;
                }
                field("Vehicle Tax"; "Vehicle Tax")
                {

                    trigger OnValidate()
                    begin
                        MakeTotal;
                    end;
                }
                field("Income Tax"; "Income Tax")
                {

                    trigger OnValidate()
                    begin
                        MakeTotal;
                    end;
                }
                field("Road Maintenance Fee"; "Road Maintenance Fee")
                {

                    trigger OnValidate()
                    begin
                        MakeTotal;
                    end;
                }
                field("Registration Fee"; "Registration Fee")
                {

                    trigger OnValidate()
                    begin
                        MakeTotal;
                    end;
                }
                field("Ownership Transfer Fee"; "Ownership Transfer Fee")
                {

                    trigger OnValidate()
                    begin
                        MakeTotal;
                    end;
                }
                field("Other Fee"; "Other Fee")
                {

                    trigger OnValidate()
                    begin
                        MakeTotal;
                    end;
                }
                field(LineTotal; LineTotal)
                {
                    Caption = 'Total Expenses';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        MakeTotal;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        MakeTotal;
    end;

    var
        LineTotal: Decimal;

    [Scope('Internal')]
    procedure MakeTotal()
    begin
        LineTotal := 0;
        LineTotal := "Income Tax" + "Road Maintenance Fee" + "Registration Fee" + "Ownership Transfer Fee" + "Other Fee" +
                      "Vehicle Tax";
    end;
}

