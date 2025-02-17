page 33020111 "Service Scheme Card"
{
    PageType = Card;
    SourceTable = Table33019873;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
            part(; 33020104)
            {
                SubPageLink = Code = FIELD(Code);
            }
            part(" Service Scheme Subform 2"; 25006999)
            {
                Caption = ' Service Scheme Subform 2';
                SubPageLink = Code = FIELD(Code);
                Visible = true;
            }
        }
    }

    actions
    {
    }
}

