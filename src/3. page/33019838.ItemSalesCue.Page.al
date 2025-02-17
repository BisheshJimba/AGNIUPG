page 33019838 "Item Sales Cue"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019838;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Posting Date From"; "Posting Date From")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        SETFILTER("Date Filter", '%1..%2', "Posting Date From", "Posting Date To");
                        CALCFIELDS("Total Sales Quantity", "Total Sales Amount");
                    end;
                }
                field("Posting Date To"; "Posting Date To")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        SETFILTER("Date Filter", '%1..%2', "Posting Date From", "Posting Date To");
                        CALCFIELDS("Total Sales Quantity", "Total Sales Amount");
                    end;
                }
                field("Average Issue"; "Average Issue")
                {
                }
                field("Reorder Point"; "Reorder Point")
                {
                }
                field("Reorder Quantity"; "Reorder Quantity")
                {
                }
                field("Max Order Quantity"; "Max Order Quantity")
                {
                }
                field(Inventory; Inventory)
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
        UserSetup.GET(USERID);
        SETFILTER("Date Filter", '%1..%2', "Posting Date From", "Posting Date To");
        //SETFILTER("Location Code",UserSetup."Default Location");
        CALCFIELDS("Total Sales Quantity", "Total Sales Amount");
    end;

    trigger OnOpenPage()
    begin
        //CalculateItemClass.RUNMODAL;
    end;

    var
        CalculateItemClass: Report "33019833";
        UserSetup: Record "91";
}

