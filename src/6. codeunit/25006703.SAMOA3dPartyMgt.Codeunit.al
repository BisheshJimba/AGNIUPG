codeunit 25006703 "SAMOA 3d Party Mgt."
{
    // 12.11.2007 P3
    //   * Added new procedure CheckSIEBin - checks if bin is used by SIE System

    TableNo = 25006705;

    trigger OnRun()
    var
        XMLFile: File;
        XMLOut: OutStream;
        adoConn: Automation;
        adoRs: Automation;
        flds: Automation;
        fld: Automation;
        XMLBuffer: Record "25006704";
        SIESetup: Record "25006701";
        SIEXMLPort: XMLport "25007449";
        SQL: Text[500];
    begin
        SIESetup.GET;

        SIENo := Rec."SIE No.";

        IF Rec."Run Mode" = Rec."Run Mode"::Post THEN BEGIN
            AutoPostJnl(Rec."Posting Unit");
            EXIT
        END;

        IF Rec."Max Date" = 0D THEN BEGIN
            Rec."Max Date" := 010199D;
            Rec."Max Time" := 000000T;
        END;

        //IF NOT VARIABLEACTIVE(adoConn) THEN
        CREATE(adoConn, FALSE, TRUE);//30.10.2012 EDMS
        adoConn.Open(Rec."DSN Name");

        CASE Rec.Direction OF
            Rec.Direction::Export:
                BEGIN
                    XMLBuffer.DELETEALL;
                    CASE Rec."Run Mode" OF
                        Rec."Run Mode"::Flow:
                            BEGIN
                                SQL := 'Select *,l.num as supl_num from Transactions t, Livraisons l,claviers c where ' +
                                     't.num = l.num_trans And l.clavier_exe=c.num And l.num_pistolet <> 0 And ' +
                                     'datediff(''n'',t.moment_fin,''' + FORMAT(CREATEDATETIME(Rec."Max Date", Rec."Max Time")) + ''')<0';
                                adoRs := adoConn.Execute(SQL);
                                WHILE NOT adoRs.EOF DO BEGIN
                                    XMLBuffer.INIT;
                                    XMLBuffer.Type := XMLBuffer.Type::Transaction;

                                    flds := adoRs.Fields;

                                    fld := flds.Item('num_trans');
                                    XMLBuffer."SIE Entry No." := fld.Value;

                                    fld := flds.Item('supl_num');
                                    XMLBuffer.Int4 := fld.Value;

                                    fld := flds.Item('moment_fin');
                                    XMLBuffer.Date1 := fld.Value;
                                    XMLBuffer.Time1 := VARIANT2TIME(fld.Value);

                                    fld := flds.Item('O_R');
                                    XMLBuffer."10Txt1" := fld.Value;

                                    fld := flds.Item('Operateur');
                                    XMLBuffer."30Txt1" := fld.Value;

                                    fld := flds.Item('clavier_lancement');
                                    XMLBuffer.Int1 := fld.Value;

                                    fld := flds.Item('num_pistolet');
                                    XMLBuffer.Int2 := fld.Value;

                                    fld := flds.Item('num_cuve');
                                    XMLBuffer.Int3 := fld.Value;

                                    fld := flds.Item('qte_demandee');
                                    XMLBuffer.Decimal1 := fld.Value;
                                    XMLBuffer.Decimal1 := XMLBuffer.Decimal1 / 100;

                                    fld := flds.Item('qte_raclee');
                                    XMLBuffer.Decimal2 := fld.Value;
                                    XMLBuffer.Decimal2 := XMLBuffer.Decimal2 / 100;

                                    fld := flds.Item('qte_livree');
                                    XMLBuffer.Decimal3 := fld.Value;
                                    XMLBuffer.Decimal3 := XMLBuffer.Decimal3 / 100;

                                    fld := flds.Item('reste_en_cuve');
                                    XMLBuffer.Decimal4 := fld.Value;

                                    fld := flds.Item('groupe');
                                    XMLBuffer.Int5 := fld.Value;

                                    XMLBuffer.INSERT;
                                    adoRs.MoveNext;
                                END;
                                SQL := 'Select max(t.moment_fin) from Transactions t, Livraisons l,claviers c where ' +
                                    't.num = l.num_trans And l.clavier_exe=c.num';
                                adoRs := adoConn.Execute(SQL);
                                flds := adoRs.Fields;
                                fld := flds.Item(0);
                                Rec."Max Date" := fld.Value;
                                Rec."Max Time" := VARIANT2TIME(fld.Value);
                            END;
                        Rec."Run Mode"::Synchronize:
                            BEGIN
                                adoRs := adoConn.Execute('select * from Utilisateurs');
                                WHILE NOT adoRs.EOF DO BEGIN
                                    XMLBuffer.INIT;
                                    XMLBuffer.Type := XMLBuffer.Type::User;
                                    flds := adoRs.Fields;
                                    fld := flds.Item(2);

                                    //XMLBuffer.INSERT;
                                    adoRs.MoveNext;
                                END;
                            END;
                    END;
                    IF XMLBuffer.COUNT > 0 THEN BEGIN
                        IF EXISTS(SIESetup."File Name") THEN ERASE(SIESetup."File Name");
                        XMLFile.CREATE(SIESetup."File Name");
                        XMLFile.CREATEOUTSTREAM(XMLOut);
                        SIEXMLPort.SetData(Rec."SIE No.");
                        SIEXMLPort.SETDESTINATION(XMLOut);
                        SIEXMLPort.SETTABLEVIEW(XMLBuffer);
                        SIEXMLPort.EXPORT;
                    END;
                END;
            Rec.Direction::Import:
                ;
        END;
        CLEAR(adoRs);
        CLEAR(adoConn)
    end;

    var
        SIENo: Code[10];
        SIE: Record "25006700";

    [Scope('Internal')]
    procedure AutoPostJnl(PostingUnit: Integer)
    var
        JnlLine: Record "25006702";
        SAMOAJnlPost: Codeunit "25006704";
    begin
        CLEAR(JnlLine);
        IF NOT JnlLine.FINDFIRST THEN EXIT;
        CODEUNIT.RUN(PostingUnit, JnlLine)
    end;

    [Scope('Internal')]
    procedure CheckSIEBin(Loc: Code[10]; Bin: Code[20]): Boolean
    var
        SIEObjCat: Record "25006708";
        SIEObj: Record "25006707";
    begin
        SIE.RESET;
        SIE.SETRANGE(SystemCode, SIE.SystemCode::SAMOA);
        SIE.SETRANGE(Active, TRUE);
        IF SIE.FINDFIRST THEN BEGIN
            SIEObjCat.SETRANGE("SIE No.", SIE."No.");
            SIEObjCat.SETRANGE(SYSType, SIEObjCat.SYSType::Bin);
            IF SIEObjCat.FINDFIRST THEN BEGIN
                SIEObj.SETRANGE("SIE No.", SIE."No.");
                SIEObj.SETRANGE(Category, SIEObjCat."No.");
                SIEObj.SETRANGE("NAV No.", Loc);
                SIEObj.SETRANGE("NAV No. 2", Bin);
                EXIT(SIEObj.FINDFIRST)
            END
        END
    end;
}

