table 25006157 "Service Plan Document Link"
{
    // 28.01.2010 EDMSB P2
    //   * Added code "Document No."-OnValidate

    Caption = 'Service Plan Document Link';

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Serv. Plan No."; Code[10])
        {
            Caption = 'Serv. Plan No.';
            TableRelation = "Vehicle Service Plan".No. WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(35; "Plan Stage Recurrence"; Integer)
        {
            Caption = 'Plan Stage Recurrence';
        }
        field(40; "Serv. Plan Stage Code"; Code[10])
        {
            Caption = 'Serv. Plan Stage Code';
            TableRelation = "Vehicle Service Plan Stage".Code WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                     Recurrence=FIELD(Plan Stage Recurrence),
                                                                     Plan No.=FIELD(Serv. Plan No.));
        }
        field(50;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Order,Return Order,Posted Order,Posted Return Order,Quote,Booking';
            OptionMembers = "Order","Return Order","Posted Order","Posted Return Order",Quote,Booking;
        }
        field(60;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF (Document Type=CONST(Order)) "Service Header EDMS".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Document Type=CONST(Return Order)) "Service Header EDMS".No. WHERE (Document Type=CONST(Return Order))
                            ELSE IF (Document Type=CONST(Posted Order)) "Posted Serv. Order Header".No.
                            ELSE IF (Document Type=CONST(Posted Return Order)) "Posted Serv. Ret. Order Header".No.;

            trigger OnValidate()
            begin
                ServicePlanManagement.DocLinkApply(Rec);
            end;
        }
    }

    keys
    {
        key(Key1;"Vehicle Serial No.","Serv. Plan No.","Plan Stage Recurrence","Serv. Plan Stage Code","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Document Type","Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ServicePlanDocumentLink.RESET;
        ServicePlanDocumentLink.SETRANGE("Vehicle Serial No.", Rec."Vehicle Serial No.");
        ServicePlanDocumentLink.SETRANGE("Serv. Plan No.", Rec."Serv. Plan No.");
        ServicePlanDocumentLink.SETRANGE("Plan Stage Recurrence", Rec."Plan Stage Recurrence");
        ServicePlanDocumentLink.SETRANGE("Serv. Plan Stage Code", Rec."Serv. Plan Stage Code");
        ServicePlanDocumentLink.SETRANGE("Document Type", Rec."Document Type");
        ServicePlanDocumentLink.SETRANGE("Document No.", Rec."Document No.");
        IF ServicePlanDocumentLink.COUNT <= 1 THEN BEGIN
          VehicleServicePlanStage.RESET;
          IF VehicleServicePlanStage.GET(Rec."Vehicle Serial No.", Rec."Serv. Plan No.",
              Rec."Plan Stage Recurrence", Rec."Serv. Plan Stage Code") THEN
            IF VehicleServicePlanStage.Status = VehicleServicePlanStage.Status::"In Process" THEN BEGIN
              VehicleServicePlanStage.Status := VehicleServicePlanStage.Status::Pending;
              VehicleServicePlanStage."Service Date" := 0D;
              VehicleServicePlanStage.MODIFY;
            END;
        END;
    end;

    var
        ServicePlanDocumentLink: Record "25006157";
        VehicleServicePlanStage: Record "25006132";
        ServicePlanManagement: Codeunit "25006103";
}

