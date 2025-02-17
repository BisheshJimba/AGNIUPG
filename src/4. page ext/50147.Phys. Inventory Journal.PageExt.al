pageextension 50147 pageextension50147 extends "Phys. Inventory Journal"
{
    Editable = IsVisible;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 58".


        //Unsupported feature: Code Modification on "CalculateInventory(Action 70).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CalcQtyOnHand.SetItemJnlLine(Rec);
        CalcQtyOnHand.RUNMODAL;
        CLEAR(CalcQtyOnHand);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CalcQtyOnHand.SetItemJnlLine(Rec);
        CalcQtyOnHand.SetPhysicalInventory;
        CalcQtyOnHand.RUNMODAL;
        CLEAR(CalcQtyOnHand);
        */
        //end;
    }

    var
        ISVisible: Boolean;
        UserSetup: Record "91";
}

