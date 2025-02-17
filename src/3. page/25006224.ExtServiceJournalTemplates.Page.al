page 25006224 "Ext. Service Journal Templates"
{
    Caption = 'External Service Journal Templates';
    PageType = List;
    SourceTable = Table25006142;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action29>")
            {
                Caption = 'Te&mplate';
                action("<Action30>")
                {
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page 25006263;
                    RunPageLink = Journal Template Name=FIELD(Name);
                }
            }
        }
    }
}

