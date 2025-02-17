page 25006280 "Platforms Templates"
{
    Caption = 'Platforms Templates';
    PageType = List;
    SourceTable = Table25006183;

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
            }
        }
        area(factboxes)
        {
            part(; 25006282)
            {
                SubPageLink = Template Code=FIELD(Code);
            }
            part(; 25006283)
            {
            }
        }
    }

    actions
    {
    }
}

