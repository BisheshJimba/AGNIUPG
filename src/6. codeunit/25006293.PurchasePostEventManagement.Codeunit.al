codeunit 25006293 "Purchase Post Event Management"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure UpdateOnBeforePostPurchaseDoc(var PurchaseHeader: Record "38")
    begin
        //EDMS1.0.00 >> //EDMD Upgrade 2017
        fUpdateVehicelSerialNo(PurchaseHeader);
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostCommitPurchaseDoc', '', false, false)]
    local procedure UpdateOnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "38"; var GenJnlPostLine: Codeunit "12"; PreviewMode: Boolean; ModifyHeader: Boolean)
    var
        PurchLine: Record "39";
        Vehicle: Record "25006005";
        ColorAssmbl: Code[20];
        UpholsteryAssmbl: Code[20];
        ColorCode: Code[20];
        InteriorCode: Code[20];
        VehoptMgt: Codeunit "25006304";
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type");
        PurchLine.SETRANGE("Document No.", PurchLine."No.");
        IF PurchLine.FINDFIRST THEN
            REPEAT
                CASE PurchLine.Type OF
                    PurchLine.Type::Item:
                        BEGIN
                            IF ("Document Profile" = "Document Profile"::"Vehicles Trade") AND
                                (PurchLine."Line Type" = PurchLine."Line Type"::Vehicle) AND
                                (PurchLine."Qty. to Receive" > 0) THEN BEGIN  //06.02.2013 EDMS P8
                                                                              //10.03.2008 EDMS P3 >>
                                Vehicle.GET(PurchLine."Vehicle Serial No.");
                                //31.05.2013 Elva Baltic P15 >>
                                IF PurchLine."Vehicle Assembly ID" <> '' THEN BEGIN
                                    ColorAssmbl := '';
                                    UpholsteryAssmbl := '';
                                    VehoptMgt.GetVehColorUpholstFromAssemblyLine(PurchLine."Vehicle Serial No.", PurchLine."Vehicle Assembly ID", ColorAssmbl, UpholsteryAssmbl)
                                END;
                                IF ColorAssmbl <> '' THEN
                                    ColorCode := ColorAssmbl
                                ELSE
                                    ColorCode := PurchLine."Vehicle Body Color Code";

                                IF ColorCode <> Vehicle."Body Color Code" THEN BEGIN
                                    Vehicle."Body Color Code" := ColorCode;
                                    Vehicle.MODIFY
                                END;

                                IF PurchLine."Vehicle Status Code" <> Vehicle."Status Code" THEN BEGIN
                                    Vehicle."Status Code" := PurchLine."Vehicle Status Code";
                                    Vehicle.MODIFY
                                END;

                                IF UpholsteryAssmbl <> '' THEN
                                    InteriorCode := UpholsteryAssmbl
                                ELSE
                                    InteriorCode := PurchLine."Vehicle Interior Code";

                                IF InteriorCode <> Vehicle."Interior Code" THEN BEGIN
                                    Vehicle."Interior Code" := InteriorCode;
                                    Vehicle.MODIFY
                                END;
                                //31.05.2013 Elva Baltic P15 <<
                                //10.03.2008 EDMS P3 <<
                                IF (PurchLine."Vehicle Assembly ID" <> '') AND PurchaseHeader.Receive THEN
                                    VehoptMgt.PostVehOptPurchLine(PurchaseHeader, PurchLine);
                            END
                            //05.12.2007 EDMS P3 <<
                        END;
                END;
            UNTIL PurchLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure fUpdateVehicelSerialNo(var recPurchHeader: Record "38")
    var
        recPurchLine: Record "39";
        cuVehSN: Codeunit "25006006";
    begin
        IF recPurchHeader."Document Profile" <> recPurchHeader."Document Profile"::"Vehicles Trade" THEN
            EXIT;
        CLEAR(cuVehSN);
        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchHeader."Document Type");
        recPurchLine.SETRANGE("Document No.", recPurchHeader."No.");
        IF recPurchLine.FIND('-') THEN
            REPEAT
                IF ("Line Type" = "Line Type"::Vehicle) AND (((recPurchLine."Qty. to Receive" <> 0) AND recPurchHeader.Receive) OR
                    ((recPurchLine."Qty. to Invoice" <> 0) AND recPurchHeader.Invoice)) THEN //06.02.2013 EDMS P8
                 BEGIN
                    IF (recPurchLine."Qty. to Receive" <> 0) THEN BEGIN
                        recPurchLine.CALCFIELDS("Vehicle Exists");
                        recPurchLine.TESTFIELD("Vehicle Exists", TRUE);
                        recPurchLine.TESTFIELD("Vehicle Serial No.");
                        cuVehSN.fDeletePurchLineTracking(recPurchLine);
                        cuVehSN.fCreatePurchLineTracking(recPurchLine);
                    END;
                END;
            UNTIL recPurchLine.NEXT = 0;
    end;
}

