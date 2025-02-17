page 25006260 "Service Spliting Lines SubForm"
{
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Set Editable property to FALSE for:
    //     "Location Code"
    //     "Unit of Measure"
    // 
    // 21.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Include
    //   Changed Visible and Editable properties of some fields

    Caption = 'Service Spliting Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Table25006128;
    SourceTableView = SORTING(Document Type, Document No., Temp. Document No., Line, Temp. Line No.)
                      ORDER(Ascending)
                      WHERE(Line = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Temp. Line No."; "Temp. Line No.")
                {
                    Visible = false;
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Quantity Share %"; "Quantity Share %")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Include; Include)
                {

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("New Quantity"; "New Quantity")
                {
                    Editable = false;
                }
                field("Amount Share %"; "Amount Share %")
                {
                    Editable = false;
                    Visible = false;
                }
                field("New Amount"; "New Amount")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

