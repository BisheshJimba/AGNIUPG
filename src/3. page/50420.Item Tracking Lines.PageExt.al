pageextension 50420 pageextension50420 extends "Item Tracking Lines"
{
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on ""Reclass_SerialNoInfoCard"(Action 67)".


        //Unsupported feature: Property Modification (RunPageLink) on ""Reclass_LotNoInfoCard"(Action 68)".


        //Unsupported feature: Property Modification (RunPageLink) on ""Line_SerialNoInfoCard"(Action 73)".


        //Unsupported feature: Property Modification (RunPageLink) on ""Line_LotNoInfoCard"(Action 74)".

        addafter("Action 64")
        {
            action("Lot No Details")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = true;

                trigger OnAction()
                var
                    ItemLedEntry: Page "38";
                    ItemLedEntryRec: Record "32";
                    TransferOrder: Record "5740";
                    ServiceLineEDMS: Record "25006146";
                    TransferLine: Record "5741";
                begin

                    TransferOrder.RESET;
                    TransferOrder.SETRANGE("No.", Rec."Source ID");
                    TransferOrder.SETFILTER("Source No.", '<>%1', '');
                    IF TransferOrder.FINDFIRST THEN BEGIN
                        TransferLine.SETRANGE("Document No.", Rec."Source ID");
                        TransferLine.SETRANGE("Item No.", Rec."Item No.");
                        IF TransferLine.FINDFIRST THEN BEGIN
                            ServiceLineEDMS.SETRANGE("Document No.", TransferLine."Source No.");
                            ServiceLineEDMS.SETRANGE("No.", TransferLine."Item No.");
                            IF ServiceLineEDMS.FINDFIRST THEN BEGIN
                                ItemLedEntryRec.SETRANGE("Transfer Source No.", ServiceLineEDMS."Document No.");
                                ItemLedEntryRec.SETRANGE("Transfer Source Type", DATABASE::"Service Header EDMS");
                                ItemLedEntryRec.SETRANGE("Item No.", ServiceLineEDMS."No.");
                                ItemLedEntryRec.SETRANGE(Open, TRUE);
                                ItemLedEntry.SETTABLEVIEW(ItemLedEntryRec);
                                ItemLedEntry.RUN;
                            END;
                        END;
                    END;
                end;
            }
        }
    }
}

