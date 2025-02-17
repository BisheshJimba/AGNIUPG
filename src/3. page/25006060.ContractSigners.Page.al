page 25006060 "Contract Signers"
{
    AutoSplitKey = true;
    Caption = 'Contract Signers';
    DataCaptionFields = "Contract Type", "Contract No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006018;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Contract No."; "Contract No.")
                {
                    Visible = false;
                }
                field("Contract Line No."; "Contract Line No.")
                {
                    Visible = false;
                }
                field("Contact No."; "Contact No.")
                {
                }
                field("Signer Name"; "Signer Name")
                {
                }
                field("Signer Social Security No."; "Signer Social Security No.")
                {
                }
                field("Signer Phone No."; "Signer Phone No.")
                {
                }
                field("Signer Fax No."; "Signer Fax No.")
                {
                }
                field("Signer E-Mail"; "Signer E-Mail")
                {
                }
            }
        }
    }

    actions
    {
    }
}

