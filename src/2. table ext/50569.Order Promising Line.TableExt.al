tableextension 50569 tableextension50569 extends "Order Promising Line"
{
    // 09.07.08 EDMS P1 - EDMS Service Management integration
    //  * Mofifyed option string of field "Source Type". New option added - Service Order EDMS
    //  * Added function TransferFromServiceLineEDMS
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 11)".

        modify("Source Type")
        {
            OptionCaption = ' ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order,Job,Service Order EDMS';

            //Unsupported feature: Property Modification (OptionString) on ""Source Type"(Field 20)".

        }


        //Unsupported feature: Code Modification on ""Requested Delivery Date"(Field 40).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CASE "Source Type" OF
          "Source Type"::Sales:
            BEGIN
        #4..8
              ServLine.GET("Source Subtype","Source ID","Source Line No.");
              "Requested Shipment Date" := ServLine."Needed by Date";
            END;
          "Source Type"::Job:
            BEGIN
              JobPlanningLine.SETRANGE("Job No.","Source ID");
              JobPlanningLine.SETRANGE("Job Contract Entry No.","Source Line No.");
              JobPlanningLine.FINDFIRST;
              "Requested Shipment Date" := JobPlanningLine."Planning Date";
            END;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..11
        //09.07.08 EDMS P1 - Added EDMS >>
          "Source Type"::"Service Order EDMS":
            BEGIN
              ServiceLineEDMS.GET("Source Subtype","Source ID","Source Line No.");
              "Requested Shipment Date" := ServiceLineEDMS."Planned Service Date";
            END;

        #12..19
        */
        //end;


        //Unsupported feature: Code Modification on ""Earliest Shipment Date"(Field 43).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CASE "Source Type" OF
          "Source Type"::Sales:
            IF "Earliest Shipment Date" <> 0D THEN BEGIN
        #4..10
          "Source Type"::Job:
            IF "Earliest Shipment Date" <> 0D THEN
              "Planned Delivery Date" := "Earliest Shipment Date";
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..13

          //09.07.08 EDMS P1 - Added EDMS >>
          "Source Type"::"Service Order EDMS":BEGIN
            ServiceLineEDMS.GET("Source Subtype","Source ID","Source Line No.");
            ServiceLineEDMS.SuspendStatusCheck(TRUE);
            ServiceLineEDMS.Reserve := ServiceLineEDMS.Reserve::Never; // Suspend automatic reservation.
            ServiceLineEDMS.VALIDATE("Planned Service Date","Earliest Shipment Date");
            "Earliest Shipment Date" := ServiceLineEDMS."Planned Service Date";
            "Planned Delivery Date" := ServiceLineEDMS."Planned Service Date";
           END;
        END;
           //09.07.08 EDMS P1 - Added EDMS <<
        */
        //end;
    }

    procedure TransferFromServiceLineEDMS(var ServiceLine: Record "25006146")
    begin
        "Source Type" := "Source Type"::"Service Order EDMS";
        "Source Subtype" := ServiceLine."Document Type";
        "Source ID" := ServiceLine."Document No.";
        "Source Line No." := ServiceLine."Line No.";
        "Item No." := ServiceLine."No.";
        "Location Code" := ServiceLine."Location Code";
        VALIDATE("Requested Delivery Date", ServiceLine."Planned Service Date");
        "Original Shipment Date" := ServiceLine."Planned Service Date";
        Description := ServiceLine.Description;
        Quantity := ServiceLine.Quantity;
        "Unit of Measure Code" := ServiceLine."Unit of Measure Code";
        "Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
        "Quantity (Base)" := ServiceLine.Quantity;
    end;

    var
        ServiceLineEDMS: Record "25006146";

    var
        ServiceLineEDMS: Record "25006146";
}

