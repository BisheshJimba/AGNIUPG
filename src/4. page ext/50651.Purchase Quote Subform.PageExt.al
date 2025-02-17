pageextension 50651 pageextension50651 extends "Purchase Quote Subform"
{
    // 06.10.2016 EB.P7 #PAR28
    //   Modified Quantity OnValidate Trigger.
    // 
    // 08.06.2016 EB.P7 #PAR28
    //   Added action "Apply Replacement"
    //   Added field "Has Replacement"
    //   Modified OnAfterGetRecord trigger.
    Editable = ItemNoAttention;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".



        //Unsupported feature: Code Modification on "Control 8.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate;
        CurrPage.UPDATE;
        */
        //end;
        addafter("Control 4")
        {
            field("Has Replacement"; "Has Replacement")
            {
                Editable = false;
            }
        }
        addafter("Control 38")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
            }
        }
        addafter("Control 14")
        {
            field("External Serv. Tracking No."; "External Serv. Tracking No.")
            {
                Visible = false;
            }
        }
        addafter("Control 62")
        {
            field("Description 2"; Rec."Description 2")
            {
            }
        }
        addafter("Control 8")
        {
            field(ABC; ABC)
            {
            }
        }
        addafter("Control 60")
        {
            field("Ordering Price Type Code"; "Ordering Price Type Code")
            {
                Visible = false;
            }
        }
        addafter("Control 50")
        {
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
        }
        addafter("Control 26")
        {
            field("Summary No."; "Summary No.")
            {
            }
        }
    }
    actions
    {
        addafter("Action 1907935204")
        {
            action("Apply Replacement")
            {
                Caption = 'Apply Replacement';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "25006513";
                begin
                    //08.06.2016 EB.P7 #PAR28 >>
                    ItemSubstSync.ReplacePurchaseLineItemNo(Rec);
                    //08.06.2016 EB.P7 #PAR28 <<
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    var
        ItemNoAttention: Text[20];


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    CLEAR(DocumentTotals);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    CLEAR(DocumentTotals);

    //08.06.2016 EB.P7 #PAR28 >>
    CheckHasReplacement;
    //08.06.2016 EB.P7 #PAR28 <<
    */
    //end;

    local procedure CheckHasReplacement()
    begin
        IF "Has Replacement" THEN
            ItemNoAttention := 'Attention'
        ELSE
            ItemNoAttention := '';
    end;
}

