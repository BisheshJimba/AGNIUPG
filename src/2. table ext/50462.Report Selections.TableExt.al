tableextension 50462 tableextension50462 extends "Report Selections"
{
    // 09.01.2015 EB.P7 EDMS
    //   * Changed field Usage OptionString to print from Service Documents
    // 
    // 12.03.2010 EDMS P2
    //   * Changed field Usage OptionString to print from Service Prepayment
    // 
    // 28.07.2008. EDMS P2
    //   * Changed field Usage OptionString to print form Service document
    fields
    {
        modify(Usage)
        {
            OptionCaption = 'S.Quote,S.Order,S.Invoice,S.Cr.Memo,S.Test,P.Quote,P.Order,P.Invoice,P.Cr.Memo,P.Receipt,P.Ret.Shpt.,P.Test,B.Stmt,B.Recon.Test,B.Check,Reminder,Fin.Charge,Rem.Test,F.C.Test,Prod. Order,S.Blanket,P.Blanket,M1,M2,M3,M4,Inv1,Inv2,Inv3,SM.Quote,SM.Order,SM.Invoice,SM.Credit Memo,SM.Contract Quote,SM.Contract,SM.Test,S.Return,P.Return,S.Shipment,S.Ret.Rcpt.,S.Work Order,Invt. Period Test,SM.Shipment,S.Test Prepmt.,P.Test Prepmt.,S.Arch. Quote,S.Arch. Order,P.Arch. Quote,P.Arch. Order,S. Arch. Return Order,P. Arch. Return Order,Asm. Order,P.Assembly Order,S.Order Pick Instruction,Serv. Order,Serv. Return Order,Serv.Test Prepmt.,Pst.Serv.Inv.Edms,Pst.Serv.Cr.M.Edms,,,,,,,,,,,,,,,,,,,,,,,,,,,C.Statement,V.Remittance,JQ,S.Invoice Draft';

            //Unsupported feature: Property Modification (OptionString) on "Usage(Field 1)".

        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Report Caption"(Field 4)".

        modify("Email Body Layout Code")
        {
            TableRelation = "Custom Report Layout".Code WHERE(Code = FIELD(Email Body Layout Code),
                                                               Report ID=FIELD(Report ID));
        }
    }

    //Unsupported feature: Variable Insertion (Variable: RecRef1) (VariableCollection) on "SendEmailDirectly(PROCEDURE 50)".


    //Unsupported feature: Variable Insertion (Variable: SalesInvHdr) (VariableCollection) on "SendEmailDirectly(PROCEDURE 50)".



    //Unsupported feature: Code Modification on "SendEmailDirectly(PROCEDURE 50)".

    //procedure SendEmailDirectly();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ShowNoBodyNoAttachmentError(ReportUsage,FoundBody,FoundAttachment);

        IF FoundBody AND NOT FoundAttachment THEN
        #4..17
              EmailAddress := COPYSTR(
                  GetNextEmailAddressFromCustomReportSelection(CustomReportSelection,DefaultEmailAddress,Usage,Sequence),
                  1,MAXSTRLEN(EmailAddress));
              ServerAttachmentFilePath := SaveReportAsPDF("Report ID",RecordVariant,"Custom Report Layout Code");
              DocumentMailing.EmailFile(
                ServerAttachmentFilePath,
        #24..30
            UNTIL NEXT = 0;
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..20

        //23
              IF RecordVariant.ISRECORD THEN BEGIN
                RecRef1.GETTABLE(RecordVariant);
                  IF RecRef1.NUMBER = DATABASE::"Sales Invoice Header" THEN BEGIN
                    RecRef1.SETTABLE(SalesInvHdr);
                    IF SalesInvHdr."Document Profile" = SalesInvHdr."Document Profile"::"Vehicles Trade" THEN
                      "Report ID" := 50031
                    ELSE IF SalesInvHdr."Document Profile" = SalesInvHdr."Document Profile"::Service THEN
                      "Report ID" := 33020236
                    ELSE IF SalesInvHdr."Document Profile" = SalesInvHdr."Document Profile"::"Spare Parts Trade" THEN
                      "Report ID" := 50013;
                    END;
                  END;
        //23
        #21..33
        */
    //end;
}

