tableextension 50566 tableextension50566 extends "Inventory Profile"
{
    // 16.04.2010 EDMS P2
    //   * Added function TransferFromServLineEDMS
    fields
    {
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 12)".

            TableRelation = "Item Variant".Code WHERE(Item No.=FIELD(Item No.),
                                                       Code=FIELD(Variant Code));
        }
    }


    //Unsupported feature: Code Modification on "TransferToTrackingEntry(PROCEDURE 9)".

    //procedure TransferToTrackingEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CASE "Source Type" OF
          0:
            BEGIN
        #4..125
              TrkgReservEntry."Source ID" := "Source ID";
              TrkgReservEntry."Source Ref. No." := "Source Ref. No.";
            END;
          ELSE
            ERROR(Text000,"Source Type");
        END;
        #132..167
            TrkgReservEntry."Expected Receipt Date" := GetExpectedReceiptDate
          ELSE
            TrkgReservEntry."Shipment Date" := "Due Date";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..128

          //23.02.2010 EDMS P2 >>
          DATABASE::"Service Line EDMS":
            BEGIN
              TrkgReservEntry."Source Type" := DATABASE::"Service Line EDMS";
              TrkgReservEntry."Source Subtype" := "Source Order Status";
              TrkgReservEntry."Source ID" := "Source ID";
              TrkgReservEntry."Source Ref. No." := "Source Ref. No.";
            END;
          //23.02.2010 EDMS P2 <<

        #129..170
        */
    //end;

    procedure TransferFromServLineEDMS(var ServLine: Record "25006146";var TrackingEntry: Record "337")
    var
        ReservEntry: Record "337";
        ReserveServLine: Codeunit "25006121";
        AutoReservedQty: Decimal;
    begin
        ServLine.TESTFIELD(Type,ServLine.Type::Item);
        "Source Type" := DATABASE::"Service Line EDMS";
        "Source Order Status" := ServLine."Document Type";
        "Source ID" := ServLine."Document No.";
        "Source Ref. No." := ServLine."Line No.";
        "Item No." := ServLine."No.";
        "Variant Code" := ServLine."Variant Code";
        "Location Code" := ServLine."Location Code";
        "Bin Code" := ServLine."Bin Code";
        ServLine.CALCFIELDS("Reserved Qty. (Base)");
        ReserveServLine.FilterReservFor(ReservEntry,ServLine);
        AutoReservedQty := - TransferBindings(ReservEntry,TrackingEntry);
        IF ServLine."Document Type" = ServLine."Document Type"::"Return Order" THEN BEGIN
          ServLine."Reserved Qty. (Base)" := ServLine."Reserved Qty. (Base)";
          AutoReservedQty := - AutoReservedQty;
        END;
        "Untracked Quantity" :=
          ServLine."Outstanding Qty. (Base)" -
          ServLine."Reserved Qty. (Base)" +
          AutoReservedQty;
        Quantity := ServLine.Quantity;
        "Remaining Quantity" := ServLine."Outstanding Quantity";
        "Quantity (Base)" := ServLine."Quantity (Base)";
        "Remaining Quantity (Base)" :=  ServLine."Outstanding Qty. (Base)";
        "Unit of Measure Code" := ServLine."Unit of Measure Code";
        "Qty. per Unit of Measure" := ServLine."Qty. per Unit of Measure";
        IF ServLine."Document Type" = ServLine."Document Type"::"Return Order" THEN
          ChangeSign;
        IsSupply := "Untracked Quantity" < 0;
        "Due Date" := ServLine."Planned Service Date";
        "Planning Flexibility" := "Planning Flexibility"::None;
        "Drop Shipment" := ServLine."Drop Shipment";
    end;
}

