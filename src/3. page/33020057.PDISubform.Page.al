page 33020057 "PDI Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table33019852;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Damage Remark"; "Damage Remark")
                {
                }
                field("Damage Details"; "Damage Details")
                {
                }
                field("Repair Type"; "Repair Type")
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Claim to"; "Claim to")
                {
                }
                field("Claim Details"; "Claim Details")
                {
                }
                field("Transporter Name"; "Transporter Name")
                {
                }
                field("Consignment No."; "Consignment No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field(Rate; Rate)
                {
                    Visible = true;
                }
            }
        }
    }

    actions
    {
    }
}

