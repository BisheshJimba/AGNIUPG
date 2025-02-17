pageextension 50023 pageextension50023 extends "General Ledger Setup"
{
    layout
    {

        //Unsupported feature: Property Insertion (Name) on "Control 65".

        addafter("Control 86")
        {
            field("Amount Decimal Places"; Rec."Amount Decimal Places")
            {
                Visible = false;
            }
            field("Amount Rounding Precision"; Rec."Amount Rounding Precision")
            {
                Visible = false;
            }
            field("Unit-Amount Rounding Precision"; Rec."Unit-Amount Rounding Precision")
            {
                Visible = false;
            }
            field("Appln. Rounding Precision"; Rec."Appln. Rounding Precision")
            {
                Visible = false;
            }
        }
        addafter("Control 84")
        {
            field("Use Accountability Center"; Rec."Use Accountability Center")
            {
            }
            field("Block Zero Value Invoice Posti"; Rec."Block Zero Value Invoice Posti")
            {
                Caption = 'Block Zero Value Invoice Posting';
            }
        }
        addafter("Control 4")
        {
            field("Exact Return Amount Mandatory"; Rec."Exact Return Amount Mandatory")
            {
            }
            field("Return Tolerance"; Rec."Return Tolerance")
            {
            }
        }
        addafter("Control 1904409301")
        {
            group("Vehicle Registration Accounts")
            {
                Caption = 'Vehicle Registration Accounts';
                field("Vehicle Tax"; Rec."Vehicle Tax")
                {
                }
                field("Income Tax"; Rec."Income Tax")
                {
                }
                field("Road Maintenance"; Rec."Road Maintenance")
                {
                }
                field("Registration Fee"; Rec."Registration Fee")
                {
                }
                field("Ownership Transfer Fee"; Rec."Ownership Transfer Fee")
                {
                }
                field("Other Fee"; Rec."Other Fee")
                {
                }
                field("Balancing A/c"; Rec."Balancing A/c")
                {
                }
            }
        }
    }
}

