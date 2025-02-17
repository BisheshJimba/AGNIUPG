page 50046 "Student Fee Components"
{
    PageType = List;
    SourceTable = Table33020184;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("Component No."; "Component No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(1);
        SETRANGE(Comment, '');
        FILTERGROUP(2);
    end;
}

