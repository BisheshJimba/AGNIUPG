page 33020104 "Service Scheme Subform"
{
    Caption = 'Service Scheme Subform';
    Editable = true;
    PageType = ListPart;
    SourceTable = Table33019862;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Type; Type)
                {
                }
                field("General Product Posting Group"; "General Product Posting Group")
                {
                }
                field("Discount %"; "Discount %")
                {
                }
            }
        }
    }

    actions
    {
    }
}

