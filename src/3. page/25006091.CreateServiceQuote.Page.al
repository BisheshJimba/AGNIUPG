page 25006091 "Create Service Quote"
{
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Created

    Caption = 'Create Service Quote';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table25006128;
    SourceTableView = WHERE(Line = CONST(Yes));

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
                    Editable = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    Editable = false;
                }
                field("Create Quote"; "Create Quote")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Create)
            {
                Caption = 'Create';
                Image = Apply;
                Promoted = true;

                trigger OnAction()
                begin
                    CreateQuote;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        DeleteDocQuote("Document Type", "Document No.");
    end;
}

