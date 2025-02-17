page 25006066 "Contract Signers Archive"
{
    AutoSplitKey = true;
    Caption = 'Contract Signers Archive';
    DataCaptionFields = "Contract Type", "Contract No.";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Table25006047;

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

