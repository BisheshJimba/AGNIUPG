page 25006011 "Process Checklist Templates"
{
    Caption = 'Process Checklist Templates';
    PageType = List;
    SourceTable = Table25006026;

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
    }

    actions
    {
        area(navigation)
        {
            action("Linked Subject Groups")
            {
                Caption = 'Linked Subject Groups';
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 25006020;
                RunPageLink = Template Code=FIELD(Code);
            }
        }
    }
}

