pageextension 50310 pageextension50310 extends "Item Substitution Entry"
{
    // 23.05.2016 EB.RC POD.DMS.Parts P439.PAR28
    //   Fields added:
    //     25006070Superseding Quantity
    //     25006080Condition Group
    // 
    // 30.06.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added "Posting Date" column
    layout
    {
        addafter("Control 18")
        {
            field("No."; Rec."No.")
            {
            }
            field("Replacement Info."; "Replacement Info.")
            {
            }
        }
        addafter("Control 10")
        {
            field("Posting Date"; "Posting Date")
            {
                Visible = false;
            }
            field("Superseding Quantity"; "Superseding Quantity")
            {
            }
            field("Condition Group"; "Condition Group")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 15".

    }
}

