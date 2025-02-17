tableextension 50158 tableextension50158 extends "Reservation Entry"
{
    // 26.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Item No. Changed
    // 
    // 08.07.08 EDMS P1 - EDMS Service Management integration
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Item Ledger Entry No."(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Action Message Adjustment"(Field 31)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5401)".


        //Unsupported feature: Property Deletion (Editable) on "Positive(Field 28)".


        //Unsupported feature: Property Deletion (Editable) on ""Item Tracking"(Field 6510)".

        field(25006000; "Item No. Changed"; Boolean)
        {
            Caption = 'Item No. Changed';
        }
    }
    keys
    {
        key(Key1; "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status")
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: ServLineEDMS) (VariableCollection) on "TextCaption(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "TextCaption(PROCEDURE 1)".

    //procedure TextCaption();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE "Source Type" OF
      DATABASE::"Item Ledger Entry":
        EXIT(ItemLedgEntry.TABLECAPTION);
    #4..22
        EXIT(TransLine.TABLECAPTION);
      DATABASE::"Service Line":
        EXIT(ServLine.TABLECAPTION);
      ELSE
        EXIT(Text001);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..25
      DATABASE::"Service Line EDMS":    //08.07.08 EDMS P1
        EXIT(ServLineEDMS.TABLECAPTION); //08.07.08 EDMS P1
    #26..28
    */
    //end;


    //Unsupported feature: Code Modification on "SummEntryNo(PROCEDURE 3)".

    //procedure SummEntryNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE "Source Type" OF
      DATABASE::"Item Ledger Entry":
        EXIT(1);
    #4..22
        EXIT(141 + "Source Subtype");
      DATABASE::"Assembly Line":
        EXIT(151 + "Source Subtype");
      ELSE
        EXIT(0);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..25

      DATABASE::"Service Line EDMS": //08.07.08 EDMS P1
        EXIT(220); //08.07.08 EDMS P1

    #26..28
    */
    //end;
}

