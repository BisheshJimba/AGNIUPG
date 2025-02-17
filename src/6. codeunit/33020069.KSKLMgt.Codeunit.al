codeunit 33020069 "KSKL Mgt"
{
    // #insert code insert data into table IIF Ver I and IFF Ver II
    // #export function exports the data from the table to CSV file
    // #remove comma is used to remove comman that would seperate the filed in excel
    //   #used in exporting


    trigger OnRun()
    begin
        beforeImportTheData;
        executeCommercial();
        executeConsumer();

        //MESSAGE('Done');
    end;

    [Scope('Internal')]
    procedure dateConversion(date: Date): Text
    var
        day: Integer;
        month: Integer;
        year: Integer;
        montxt: Text;
        finalmon: Text;
    begin
        IF date = 0D THEN
            EXIT;
        day := DATE2DMY(date, 1);
        month := DATE2DMY(date, 2);
        year := DATE2DMY(date, 3);

        CASE month OF
            1:
                montxt := 'JAN';
            2:
                montxt := 'FEB';
            3:
                montxt := 'MAR';
            4:
                montxt := 'APR';
            5:
                montxt := 'MAY';
            6:
                montxt := 'JUN';
            7:
                montxt := 'JUL';
            8:
                montxt := 'AUG';
            9:
                montxt := 'SEP';
            10:
                montxt := 'OCT';
            11:
                montxt := 'NOV';
            12:
                montxt := 'DEC';
        END;

        IF day <= 9 THEN
            finalmon := '0' + FORMAT(day) + '-' + montxt + '-' + FORMAT(year)
        ELSE
            finalmon := FORMAT(day) + '-' + montxt + '-' + FORMAT(year);


        EXIT(finalmon);
    end;

    [Scope('Internal')]
    procedure dateValidationGtrEqlTo(date: Date; date2Compare: Date)
    begin
        IF date >= date2Compare THEN
            ERROR('The date does not match with the given date');
    end;

    local procedure dateValidationGtrThan(date: Date; date2Compare: Date)
    begin
        IF date > date2Compare THEN
            ERROR('The date does not match with the given date');
    end;

    [Scope('Internal')]
    procedure dateValidationLessThan(date: Date; date2Compare: Date)
    begin
        IF date < date2Compare THEN
            ERROR('The date does not match with the given date');
    end;

    [Scope('Internal')]
    procedure dateValidationLessEqlTo(date: Date; date2Compare: Date)
    begin
        IF date <= date2Compare THEN
            ERROR('The date does not match with the given date');
    end;

    [Scope('Internal')]
    procedure allowedDisallowedChars(TextChars: Text)
    var
        i: Integer;
        Length: Integer;
    begin
        IF TextChars <> '' THEN BEGIN
            IF STRLEN(TextChars) <> 0 THEN BEGIN
                Length := 1;
                REPEAT
                    IF TextChars[Length] IN ['`', '!', '#', '$', '%', '^', '*', '+', ':', ';', '|', '<', '>', '?', '_', '{', '}', '[', ']'] THEN
                        ERROR('The character is not allowed');
                    Length += 1;
                UNTIL Length > STRLEN(TextChars);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure validateNumbersOnly(Num: Code[20])
    var
        Length: Integer;
    begin
        IF Num <> '' THEN BEGIN
            IF STRLEN(Num) <> 0 THEN BEGIN
                Length := 1;
                REPEAT
                    IF Num[Length] IN ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] THEN BEGIN
                    END
                    ELSE
                        ERROR('The field must contain numbers only.');
                    Length += 1;
                UNTIL Length > STRLEN(Num);
            END
            ELSE
                ERROR('Field cant be kept empty.');
        END;
    end;

    local procedure insertAndUpdateHDLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                    CLEAR(IFFVerification1);
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::HD);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateHDCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::HD);
                        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier HD");
                        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
                        insertAndUpdateHDCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateCFLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        LoanLine1: Record "33020063";
        noInstallOverdue: Integer;
        Amt30: Decimal;
        Amt60: Decimal;
        Amt90: Decimal;
        Amt120: Decimal;
        Amt150: Decimal;
        Amt180: Decimal;
        Amt180more: Decimal;
        LoanLineDPD: Record "33020063";
        DPDDay: Integer;
        PaymentLine: Record "33020072";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                LoanHeader.CALCFIELDS("Date to Clear Loan");
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                    CLEAR(IFFVerification1);
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::CF);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateCFCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);
                    END ELSE BEGIN
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No."); //Credit Facilty No.
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::CF);
                        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier CF");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                        insertAndUpdateCFCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateCHLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET; //MAMTA
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Payment Dealy History Flag" = KSKLSetup."Skiping Payment Flag" THEN BEGIN //231
                    Customer.GET(LoanHeader."Customer No.");
                    IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                        LoanLine.RESET;
                        LoanLine.SETRANGE(LoanLine."Loan No.", LoanHeader."Loan No.");
                        LoanLine.SETRANGE(LoanLine."Line Cleared", FALSE);
                        IF LoanLine.FINDFIRST THEN;
                        IFFVerification1.RESET;
                        IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::CH);
                        IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                        IF IFFVerification1.FINDFIRST THEN BEGIN
                            insertAndUpdateCHCommercial(IFFVerification1, LoanHeader);
                            IFFVerification1.MODIFY(TRUE);
                        END ELSE BEGIN
                            IFFVerification1.INIT;
                            IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                            IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::CH);
                            IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier CH");
                            IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                            insertAndUpdateCHCommercial(IFFVerification1, LoanHeader);
                            IFFVerification1.INSERT(TRUE);
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateCSLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                CLEAR(IFFVerification1);
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::CS);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateCSCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::CS);
                        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier CS");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                        insertAndUpdateCSCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateRSLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::RS);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateRSCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);

                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::RS);
                        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier RS");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                        insertAndUpdateRSCommercial(IFFVerification1, LoanHeader);
                        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateBRLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
        CusRel: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        //LoanHeader.SETRANGE("Loan No.",'LO-000042');
        IF LoanHeader.FINDSET THEN
            REPEAT
                Customer.GET(LoanHeader."Customer No.");
                IF CusRel.GET(Customer."Related Entity Number") THEN;
                IF CusRel."Has BR" THEN BEGIN
                    IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                        IFFVerification1.RESET;
                        IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::BR);
                        IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                        IF IFFVerification1.FINDFIRST THEN BEGIN
                            insertAndUpdateBRCommercial(IFFVerification1, LoanHeader);
                            IFFVerification1.MODIFY(TRUE);
                        END ELSE BEGIN
                            Customer.GET(LoanHeader."Customer No.");
                            IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                            IFFVerification1.INIT;
                            IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                            IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::BR);
                            IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier BR");
                            IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                            IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
                            insertAndUpdateBRCommercial(IFFVerification1, LoanHeader);
                            IFFVerification1.INSERT(TRUE);
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateSSLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN

                    CLEAR(IFFVerification2);
                    Customer.GET(LoanHeader."Customer No.");
                    IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                        IFFVerification2.RESET;
                        IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                        IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::SS);
                        IFFVerification2.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                        IF IFFVerification2.FINDFIRST THEN BEGIN
                            insertAndUpdateSSCommercial(IFFVerification2, LoanHeader);
                            IFFVerification2.MODIFY(TRUE);
                        END ELSE BEGIN
                            Customer.GET(LoanHeader."Customer No.");
                            IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                            IFFVerification2.INIT;
                            IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                            IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::SS);
                            IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier SS");
                            IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
                            insertAndUpdateSSCommercial(IFFVerification2, LoanHeader);
                            IFFVerification2.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
                            IFFVerification2.INSERT(TRUE);
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateVSLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN

                    Customer.GET(LoanHeader."Customer No.");
                    IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                    IF CustomerRelatedEntity."Security Valuator Type" <> KSKLSetup."Skip VR and VS" THEN BEGIN
                        IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                            IFFVerification2.RESET;
                            IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                            IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::VS);
                            IFFVerification2.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                            IF IFFVerification2.FINDFIRST THEN BEGIN

                                insertAndUpdateVSCommercial(IFFVerification2, LoanHeader, CustomerRelatedEntity);

                                IFFVerification2.MODIFY(TRUE);
                            END ELSE BEGIN
                                Customer.GET(LoanHeader."Customer No.");
                                IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                                IFFVerification2.INIT;
                                IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                                IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::VS);
                                IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier VS");
                                IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
                                IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");
                                IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");
                                insertAndUpdateVSCommercial(IFFVerification2, LoanHeader, CustomerRelatedEntity);
                                IFFVerification2.INSERT(TRUE);
                            END;
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateVRLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN//3/20/2023
                    CLEAR(IFFVerification2);
                    Customer.GET(LoanHeader."Customer No.");
                    IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                    IF CustomerRelatedEntity."Security Valuator Type" <> KSKLSetup."Skip VR and VS" THEN BEGIN
                        IF CustomerRelatedEntity."Valuator Entity Type" <> '001' THEN BEGIN //hardcoded
                            IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                                IFFVerification2.RESET;
                                IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                                IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::VR);
                                IFFVerification2.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                                IF IFFVerification2.FINDFIRST THEN BEGIN
                                    insertAndUpdateVRCommercial(IFFVerification2, LoanHeader);
                                    IFFVerification2.MODIFY(TRUE);
                                END ELSE BEGIN
                                    Customer.GET(LoanHeader."Customer No.");
                                    IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                                    IFFVerification2.INIT;
                                    IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                                    IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::VR);
                                    IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier VR");
                                    IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
                                    IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
                                    insertAndUpdateVRCommercial(IFFVerification2, LoanHeader);
                                    IFFVerification2.INSERT(TRUE);
                                END;
                            END;
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateTLLoanwiseCommercial()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Commercial)" THEN BEGIN
                    CLEAR(IFFVerification2);
                    IFFVerification2.RESET;
                    IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                    IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::TL);
                    IFFVerification2.SETRANGE("File Type", IFFVerification1."File Type"::Commercial);
                    IF IFFVerification2.FINDFIRST THEN BEGIN
                        insertAndUpdateTLCommercial(IFFVerification2, LoanHeader);
                        IFFVerification2.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IFFVerification2.INIT;
                        IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                        IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::TL);
                        IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier TL");
                        insertAndUpdateTLCommercial(IFFVerification2, LoanHeader);
                        IFFVerification2.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure timeConversion(InputTime: Time) timeR: Text
    var
        TimeInText: Text;
        TimeParts: array[3] of Decimal;
        time2Text: Text;
        time3Text: Text;
        time1text: Text;
    begin
        IF InputTime = 0T THEN
            ERROR('Input Time Value');

        TimeInText := FORMAT(InputTime);

        EVALUATE(TimeParts[1], COPYSTR(TimeInText, 1, 2));
        EVALUATE(TimeParts[2], COPYSTR(TimeInText, 4, 2));
        EVALUATE(TimeParts[3], COPYSTR(TimeInText, 7, 2));

        IF COPYSTR(TimeInText, 10, 2) = 'PM' THEN
            time1text := FORMAT(TimeParts[1] + 12)
        ELSE BEGIN
            IF TimeParts[1] / 10 < 1 THEN
                time1text := '0' + FORMAT(TimeParts[1])
            ELSE
                time1text := FORMAT(TimeParts[1]);
        END;
        IF TimeParts[2] / 10 < 1 THEN
            time2Text := '0' + FORMAT(TimeParts[2])
        ELSE
            time2Text := FORMAT(TimeParts[2]);
        IF TimeParts[3] / 10 < 1 THEN
            time3Text := '0' + FORMAT(TimeParts[3])
        ELSE
            time3Text := FORMAT(TimeParts[3]);
        timeR := time1text + time2Text + time3Text;
    end;

    [Scope('Internal')]
    procedure exportHeaderFile()
    var
        lineNo: Integer;
        TempCSVBuffer: Record "1234" temporary;
        IFFVerficationI: Record "33019802";
        filePath: Text;
        HDLineNo: Integer;
        IFFVerificationII: Record "33019803";
        Seperator: Text;
        varOldfile: Text;
        varNewfile: Text;
        New: Boolean;
        KSKLSetup: Record "33019801";
        filename: Text;
        finalPathName: Text;
        LoanHeader: Record "33020062";
        "count": Integer;
    begin
        lineNo := 0; //please work on this code
        Seperator := '|';
        KSKLSetup.GET;
        //HD starts Here
        IFFVerficationI.RESET;
        IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
        IF IFFVerficationI.FINDFIRST THEN
            IF IFFVerficationI.Type = IFFVerficationI.Type::HD THEN BEGIN //HD Begins
                lineNo += 1;
                TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Segment Identifier" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Reporting Date" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Reporting Time" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Date of Prep File" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Nature of Data" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."IFF Version ID(Commercial)");
                TempCSVBuffer.InsertEntry(lineNo, 8, '');
                TempCSVBuffer.InsertEntry(lineNo, 9, '');
                TempCSVBuffer.InsertEntry(lineNo, 10, '');
                TempCSVBuffer.InsertEntry(lineNo, 11, '');
                TempCSVBuffer.InsertEntry(lineNo, 12, '');
                TempCSVBuffer.InsertEntry(lineNo, 13, '');
                TempCSVBuffer.InsertEntry(lineNo, 14, '');
                TempCSVBuffer.InsertEntry(lineNo, 15, '');
                TempCSVBuffer.InsertEntry(lineNo, 16, '');
                TempCSVBuffer.InsertEntry(lineNo, 17, '');
                TempCSVBuffer.InsertEntry(lineNo, 18, '');
                TempCSVBuffer.InsertEntry(lineNo, 19, '');
                TempCSVBuffer.InsertEntry(lineNo, 20, '');
                TempCSVBuffer.InsertEntry(lineNo, 21, '');
                TempCSVBuffer.InsertEntry(lineNo, 22, '');
                TempCSVBuffer.InsertEntry(lineNo, 23, '');
                TempCSVBuffer.InsertEntry(lineNo, 24, '');
                TempCSVBuffer.InsertEntry(lineNo, 25, '');
                TempCSVBuffer.InsertEntry(lineNo, 26, '');
                TempCSVBuffer.InsertEntry(lineNo, 27, '');
                TempCSVBuffer.InsertEntry(lineNo, 28, '');
                TempCSVBuffer.InsertEntry(lineNo, 29, '');
                TempCSVBuffer.InsertEntry(lineNo, 30, '');
                TempCSVBuffer.InsertEntry(lineNo, 31, '');
                TempCSVBuffer.InsertEntry(lineNo, 32, '');
                TempCSVBuffer.InsertEntry(lineNo, 33, '');
                TempCSVBuffer.InsertEntry(lineNo, 34, '');
                TempCSVBuffer.InsertEntry(lineNo, 35, '');
                TempCSVBuffer.InsertEntry(lineNo, 36, '');
                TempCSVBuffer.InsertEntry(lineNo, 37, '');
                TempCSVBuffer.InsertEntry(lineNo, 38, '');
                TempCSVBuffer.InsertEntry(lineNo, 39, '');
                TempCSVBuffer.InsertEntry(lineNo, 40, '');
                TempCSVBuffer.InsertEntry(lineNo, 41, '');
                TempCSVBuffer.InsertEntry(lineNo, 42, '');
                TempCSVBuffer.InsertEntry(lineNo, 43, '');
                TempCSVBuffer.InsertEntry(lineNo, 44, '');
                TempCSVBuffer.InsertEntry(lineNo, 45, '');
                TempCSVBuffer.InsertEntry(lineNo, 46, '');
                TempCSVBuffer.InsertEntry(lineNo, 47, '');
                TempCSVBuffer.InsertEntry(lineNo, 48, '');
                TempCSVBuffer.InsertEntry(lineNo, 49, '');
                TempCSVBuffer.InsertEntry(lineNo, 50, '');
                TempCSVBuffer.InsertEntry(lineNo, 51, '');
                TempCSVBuffer.InsertEntry(lineNo, 52, '');
                TempCSVBuffer.InsertEntry(lineNo, 53, '');
                TempCSVBuffer.InsertEntry(lineNo, 54, '');
                TempCSVBuffer.InsertEntry(lineNo, 55, '');
            END;


        //HD Ends Here

        /*IF TempCSVBuffer.FINDLAST THEN
          lineNo := TempCSVBuffer."Line No.";  */

        //CF Starts Here
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        //LoanHeader.SETRANGE("Loan No.",'LO-000042');
        IF LoanHeader.FINDSET THEN
            REPEAT
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::CF THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Prev Data Prov ID No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Prev Data Prov Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Prev Loan No" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."Credit Facility Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Purpose of Credit Facility" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."Ownership Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, FORMAT(IFFVerficationI."Credit Facilty Open Date") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, removeComma(FORMAT(IFFVerficationI."Customer Credit Limit")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, removeComma(FORMAT(IFFVerficationI."Credit Facility Sanction Amt")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."Credit Facilty Sanction Curr" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."Disbursement Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, removeComma(FORMAT(IFFVerficationI."Disbursement Amount")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI."Natural Credit Exp Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."Repayment Frequency" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, FORMAT(IFFVerficationI."No. of Installments") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, removeComma(FORMAT(IFFVerficationI."Amount of Installment")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."Immediate Preceeding Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, removeComma(FORMAT(IFFVerficationI."Total Outstanding Balance")) + Seperator);
                            IF IFFVerficationI."Highest Credit Usage" <> 0 THEN
                                TempCSVBuffer.InsertEntry(lineNo, 23, FORMAT(IFFVerficationI."Highest Credit Usage") + Seperator)
                            ELSE
                                TempCSVBuffer.InsertEntry(lineNo, 23, '' + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."Date of Last Repay" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, removeComma(FORMAT(IFFVerficationI."Last Repay Amount")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, FORMAT(IFFVerficationI."Payment Delay Days") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."Payment Delay Indicator" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, FORMAT(IFFVerficationI."Number of days over due") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, FORMAT(IFFVerficationI."No of Installments Overdue") + Seperator); //number of payment
                            TempCSVBuffer.InsertEntry(lineNo, 30, removeComma(FORMAT(IFFVerficationI."Amount OverDue")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, removeComma(FORMAT(IFFVerficationI."Amount OverDue 1-30 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, removeComma(FORMAT(IFFVerficationI."Amount OverDue 31-60 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, removeComma(FORMAT(IFFVerficationI."Amount OverDue 61-90 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, removeComma(FORMAT(IFFVerficationI."Amount OverDue 91-120 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, removeComma(FORMAT(IFFVerficationI."Amount OverDue 121-150 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, removeComma(FORMAT(IFFVerficationI."Amount OverDue 151-180 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, removeComma(FORMAT(IFFVerficationI."Amount  Overdue 181 or More")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI."Assets Classification" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerficationI."Credit Facility Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerficationI."Credit Facility Closing Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerficationI."Reason for Closure" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerficationI."Security Coverage Flag" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerficationI."Legal Action Taken" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerficationI."Info Update On" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, FORMAT(IFFVerficationI."Time of Update"));
                            TempCSVBuffer.InsertEntry(lineNo, 46, '');
                            TempCSVBuffer.InsertEntry(lineNo, 47, '');
                            TempCSVBuffer.InsertEntry(lineNo, 48, '');
                            TempCSVBuffer.InsertEntry(lineNo, 49, '');
                            TempCSVBuffer.InsertEntry(lineNo, 50, '');
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');//22
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //CF Ends Here

                //CH Starts Here

                IF LoanHeader."Payment Dealy History Flag" = KSKLSetup."Skiping Payment Flag" THEN BEGIN //231
                    IFFVerficationI.RESET;
                    IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                    IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                    IF IFFVerficationI.FINDSET THEN
                        REPEAT
                            IF IFFVerficationI.Type = IFFVerficationI.Type::CH THEN BEGIN
                                lineNo += 1;
                                TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Segment Identifier" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Date Reported" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Installment Due Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Payment Due Settlment Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 8, FORMAT(IFFVerficationI."Payment Delay Days"));
                                TempCSVBuffer.InsertEntry(lineNo, 9, '');
                                TempCSVBuffer.InsertEntry(lineNo, 10, '');
                                TempCSVBuffer.InsertEntry(lineNo, 11, '');
                                TempCSVBuffer.InsertEntry(lineNo, 12, '');
                                TempCSVBuffer.InsertEntry(lineNo, 13, '');
                                TempCSVBuffer.InsertEntry(lineNo, 14, '');
                                TempCSVBuffer.InsertEntry(lineNo, 15, '');
                                TempCSVBuffer.InsertEntry(lineNo, 16, '');
                                TempCSVBuffer.InsertEntry(lineNo, 17, '');
                                TempCSVBuffer.InsertEntry(lineNo, 18, '');
                                TempCSVBuffer.InsertEntry(lineNo, 19, '');
                                TempCSVBuffer.InsertEntry(lineNo, 20, '');
                                TempCSVBuffer.InsertEntry(lineNo, 21, '');
                                TempCSVBuffer.InsertEntry(lineNo, 22, '');
                                TempCSVBuffer.InsertEntry(lineNo, 23, '');
                                TempCSVBuffer.InsertEntry(lineNo, 24, '');
                                TempCSVBuffer.InsertEntry(lineNo, 25, '');
                                TempCSVBuffer.InsertEntry(lineNo, 26, '');
                                TempCSVBuffer.InsertEntry(lineNo, 27, '');
                                TempCSVBuffer.InsertEntry(lineNo, 28, '');
                                TempCSVBuffer.InsertEntry(lineNo, 29, '');
                                TempCSVBuffer.InsertEntry(lineNo, 30, '');
                                TempCSVBuffer.InsertEntry(lineNo, 31, '');
                                TempCSVBuffer.InsertEntry(lineNo, 32, '');
                                TempCSVBuffer.InsertEntry(lineNo, 33, '');
                                TempCSVBuffer.InsertEntry(lineNo, 34, '');
                                TempCSVBuffer.InsertEntry(lineNo, 35, '');
                                TempCSVBuffer.InsertEntry(lineNo, 36, '');
                                TempCSVBuffer.InsertEntry(lineNo, 37, '');
                                TempCSVBuffer.InsertEntry(lineNo, 38, '');
                                TempCSVBuffer.InsertEntry(lineNo, 39, '');
                                TempCSVBuffer.InsertEntry(lineNo, 40, '');
                                TempCSVBuffer.InsertEntry(lineNo, 41, '');
                                TempCSVBuffer.InsertEntry(lineNo, 42, '');
                                TempCSVBuffer.InsertEntry(lineNo, 43, '');
                                TempCSVBuffer.InsertEntry(lineNo, 44, '');
                                TempCSVBuffer.InsertEntry(lineNo, 45, '');
                                TempCSVBuffer.InsertEntry(lineNo, 46, '');
                                TempCSVBuffer.InsertEntry(lineNo, 47, '');
                                TempCSVBuffer.InsertEntry(lineNo, 48, '');
                                TempCSVBuffer.InsertEntry(lineNo, 49, '');
                                TempCSVBuffer.InsertEntry(lineNo, 50, '');
                                TempCSVBuffer.InsertEntry(lineNo, 51, '');
                                TempCSVBuffer.InsertEntry(lineNo, 52, '');
                                TempCSVBuffer.InsertEntry(lineNo, 53, '');
                                TempCSVBuffer.InsertEntry(lineNo, 54, '');
                                TempCSVBuffer.InsertEntry(lineNo, 55, '');
                            END;
                        UNTIL IFFVerficationI.NEXT = 0;
                END;
                //CH Ends Here

                //CS Starts Here
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::CS THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Prev Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Subject Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."Subject Prev Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."Date of Comp Redg" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerficationI.PAN + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerficationI."Previous PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerficationI."PAN Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."PAN Issue District" + Seperator);
                            //Start from here Mamata
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."Comp Redg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerficationI."Comp Redg Issued Authority" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI."Address1 Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."Address1 Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerficationI."Address1 Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerficationI."Address1 Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."Address1 District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerficationI."Address1 PO Box" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerficationI."Address1 Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."Address 2 Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerficationI."Address 2 Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerficationI."Address 2 Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."Address 2 Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerficationI."Address 2 District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerficationI."Address 2 Power BOX" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, IFFVerficationI."Address 2 Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerficationI."Telephone 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerficationI."Telephone Number 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerficationI."Mobile Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerficationI."Business Activity Code" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerficationI."Fax 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerficationI.Fax2 + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerficationI."Email Address" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 39, '');
                            TempCSVBuffer.InsertEntry(lineNo, 40, '');
                            TempCSVBuffer.InsertEntry(lineNo, 41, '');
                            TempCSVBuffer.InsertEntry(lineNo, 42, '');
                            TempCSVBuffer.InsertEntry(lineNo, 43, '');
                            TempCSVBuffer.InsertEntry(lineNo, 44, '');
                            TempCSVBuffer.InsertEntry(lineNo, 45, '');
                            TempCSVBuffer.InsertEntry(lineNo, 46, '');
                            TempCSVBuffer.InsertEntry(lineNo, 47, '');
                            TempCSVBuffer.InsertEntry(lineNo, 48, '');
                            TempCSVBuffer.InsertEntry(lineNo, 49, '');
                            TempCSVBuffer.InsertEntry(lineNo, 50, '');
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //CS Ends Here

                //RS Starts Here
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::RS THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Related Entity Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Nature of Relationship" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."Related Entities Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."Date of Birth Comp Redg" + Seperator);// RE date of birth/ Comp Registrtion Date
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerficationI."RE Comp Redg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerficationI."RE Comp Reg No. Issued Auth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerficationI."RE Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."RE Prev Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."RE Citizenship No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerficationI."RE Citizen No. Issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI."RE PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."RE Previous PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerficationI."RE PAN No. Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerficationI."RE PAN issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."RE Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerficationI."RE Previous Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerficationI."Passport No. Expiry Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."RE Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerficationI."RE Previous Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerficationI."RE Voter ID No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."IN Embassy Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerficationI."IN Embasssy Reg No. Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, FORMAT(IFFVerficationI."Percentage of Control") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, IFFVerficationI."Guarantee Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerficationI."Date of Leaving" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerficationI."Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerficationI."Grand Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerficationI."Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerficationI."Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerficationI."Mother Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerficationI."Related Indiv Nationality" + Seperator);//Related Entity Nationality...verify
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI."RE Gender" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerficationI."RE Entities Address Type" + Seperator);// RE Address1 Type
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerficationI."RE Address 1 Line 1" + Seperator); //RE Address1 Line 1
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerficationI."RE Entities Address Line 2" + Seperator); //RE Address1 Line2
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerficationI."RE Entities Address Line 3" + Seperator); //RE Address1 Line3
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerficationI."RE Entities Address District" + Seperator); // RE Address1 District
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerficationI."RE Entities Address P.O Box No" + Seperator); // RE Address1 PO Box Number
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerficationI."RE Entities Address Country" + Seperator); //RE Address1 Country
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerficationI."RE Entities Telephone No.1" + Seperator); //RE Telephone number1
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerficationI."RE Entities Telephone No.2" + Seperator);// RE Telephone Number 2
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerficationI."Related Indv. Mobile No." + Seperator); // RE Mobile number
                            TempCSVBuffer.InsertEntry(lineNo, 49, IFFVerficationI.Fax1 + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 50, IFFVerficationI.Fax2 + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 51, IFFVerficationI."RE Entities Email Address" + Seperator);// RE Email Address
                            TempCSVBuffer.InsertEntry(lineNo, 52, IFFVerficationI.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //RS Ends Here

                //BR Starts Here
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::BR THEN BEGIN
                            IF IFFVerficationI."Related Entity Type" <> '001' THEN BEGIN //7/17/2023 aryan dai
                                lineNo += 1;
                                TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Segment Identifier" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Customer No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."BR Entity Type" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Nature of Relationship" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."BR RE Name" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Legal Status" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."BR RE DOB/Date of Reg" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerficationI."BR RE Comp Reg No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerficationI."BR RE Comp Reg No. Issue Auth" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerficationI."BR RE Citizenship No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."BR RE Prev. Citizenship No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."BR RE Citizen No. Issued Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerficationI."BR RE Citizen No. Issue Dist" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI."BR RE PAN" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."BR RE Prev. PAN" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerficationI."BR RE PAN No. Issued Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerficationI."BR RE PAN Issued District" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."BR RE Passport" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerficationI."BR RE Previous Passport" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerficationI."BR RE Passport No. Exp Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."BR RE Voter ID" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerficationI."BR RE Prev. Voter ID" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerficationI."BR RE Voter ID No. Issued Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."BR Re In Emb Regd No" + Seperator);// BR RE Indian Embassy Registration number
                                TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerficationI."BR RE IN Emb Reg No. Issue Dat" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerficationI."BR RE Gender" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 30, FORMAT(IFFVerficationI."BR RE Percentage of control") + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerficationI."BR RE Date of Leaving" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerficationI."BR RE Father Name" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerficationI."BR RE Grand Father Name" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerficationI."BR RE Spouse1 Name" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerficationI."BR RE Spouse2 Name" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerficationI."BR RE Mother Name" + Seperator);
                                IF IFFVerficationI."BR Entity Type" = '001' THEN BEGIN
                                    TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerficationI."BR Nationality" + Seperator);//2/1
                                END ELSE
                                    TempCSVBuffer.InsertEntry(lineNo, 37, '' + Seperator);//2/1
                                TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI."BR RE Address Type" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerficationI."BR RE Address Line 1" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerficationI."BR RE Address Line 2" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerficationI."BR RE Address Line 3" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerficationI."BR RE District" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerficationI."BR RE P.O. Box" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerficationI."BR RE Country" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerficationI."BR RE Telephone No. 1" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerficationI."BR RE Telephone No. 2" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerficationI."BR RE Mobile No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerficationI."BR RE Fax 1" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 49, IFFVerficationI."BR RE Fax2" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 50, IFFVerficationI."BR RE Email" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 51, IFFVerficationI.Group);
                                TempCSVBuffer.InsertEntry(lineNo, 52, '');
                                TempCSVBuffer.InsertEntry(lineNo, 53, '');
                                TempCSVBuffer.InsertEntry(lineNo, 54, '');
                                TempCSVBuffer.InsertEntry(lineNo, 55, '');
                            END; //7/17/2023 Aryan dai
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //BR Ends Here

                //SS Starts Here
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN
                    IFFVerificationII.RESET;
                    IFFVerificationII.SETRANGE("Loan No.", LoanHeader."Loan No.");
                    IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                    IF IFFVerificationII.FINDSET THEN
                        REPEAT
                            IF IFFVerificationII.Type = IFFVerificationII.Type::SS THEN BEGIN
                                lineNo += 1;
                                TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Segment Identifier" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerificationII."Data Provider Branch ID" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerificationII."Loan No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerificationII."Customer Number" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerificationII."Type of Security" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerificationII."Security Ownership Type" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerificationII."Valuator Type" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerificationII."Description of Security" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerificationII."Nature of Charge" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerificationII."Security Coverage Percentage" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 12, FORMAT(IFFVerificationII."Latest Value of Security") + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerificationII."Date of Latest Valuation");
                                TempCSVBuffer.InsertEntry(lineNo, 14, '');
                                TempCSVBuffer.InsertEntry(lineNo, 15, '');
                                TempCSVBuffer.InsertEntry(lineNo, 16, '');
                                TempCSVBuffer.InsertEntry(lineNo, 17, '');
                                TempCSVBuffer.InsertEntry(lineNo, 18, '');
                                TempCSVBuffer.InsertEntry(lineNo, 19, '');
                                TempCSVBuffer.InsertEntry(lineNo, 20, '');
                                TempCSVBuffer.InsertEntry(lineNo, 21, '');
                                TempCSVBuffer.InsertEntry(lineNo, 22, '');
                                TempCSVBuffer.InsertEntry(lineNo, 23, '');
                                TempCSVBuffer.InsertEntry(lineNo, 24, '');
                                TempCSVBuffer.InsertEntry(lineNo, 25, '');
                                TempCSVBuffer.InsertEntry(lineNo, 26, '');
                                TempCSVBuffer.InsertEntry(lineNo, 27, '');
                                TempCSVBuffer.InsertEntry(lineNo, 28, '');
                                TempCSVBuffer.InsertEntry(lineNo, 29, '');
                                TempCSVBuffer.InsertEntry(lineNo, 30, '');
                                TempCSVBuffer.InsertEntry(lineNo, 31, '');
                                TempCSVBuffer.InsertEntry(lineNo, 32, '');
                                TempCSVBuffer.InsertEntry(lineNo, 33, '');
                                TempCSVBuffer.InsertEntry(lineNo, 34, '');
                                TempCSVBuffer.InsertEntry(lineNo, 35, '');
                                TempCSVBuffer.InsertEntry(lineNo, 36, '');
                                TempCSVBuffer.InsertEntry(lineNo, 37, '');
                                TempCSVBuffer.InsertEntry(lineNo, 38, '');
                                TempCSVBuffer.InsertEntry(lineNo, 39, '');
                                TempCSVBuffer.InsertEntry(lineNo, 40, '');
                                TempCSVBuffer.InsertEntry(lineNo, 41, '');
                                TempCSVBuffer.InsertEntry(lineNo, 42, '');
                                TempCSVBuffer.InsertEntry(lineNo, 43, '');
                                TempCSVBuffer.InsertEntry(lineNo, 44, '');
                                TempCSVBuffer.InsertEntry(lineNo, 45, '');
                                TempCSVBuffer.InsertEntry(lineNo, 46, '');
                                TempCSVBuffer.InsertEntry(lineNo, 47, '');
                                TempCSVBuffer.InsertEntry(lineNo, 48, '');
                                TempCSVBuffer.InsertEntry(lineNo, 49, '');
                                TempCSVBuffer.InsertEntry(lineNo, 50, '');
                                TempCSVBuffer.InsertEntry(lineNo, 51, '');
                                TempCSVBuffer.InsertEntry(lineNo, 52, '');
                                TempCSVBuffer.InsertEntry(lineNo, 53, '');
                                TempCSVBuffer.InsertEntry(lineNo, 54, '');
                                TempCSVBuffer.InsertEntry(lineNo, 55, '');
                            END;
                        UNTIL IFFVerificationII.NEXT = 0;
                END;
                //SS Ends Here

                //VS Starts Here
                IFFVerificationII.RESET;
                IFFVerificationII.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                IF IFFVerificationII.FINDSET THEN
                    REPEAT
                        IF IFFVerificationII.Type = IFFVerificationII.Type::VS THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerificationII."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerificationII."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerificationII."Customer Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerificationII."Previous Customer No" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerificationII."Valuator Entity Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerificationII."Valuator Entity's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerificationII."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerificationII."VE DOB/Comp Reg Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerificationII."VE Comp Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerificationII."VE Comp Reg No. Issue Auth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerificationII."VE Citizenship No" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerificationII."VE Previous Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerificationII."VE Citizenship No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerificationII."VE Citizenship No. Issued Dist" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerificationII."VE PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerificationII."VE Prev PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerificationII."VE PAN No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerificationII."VE PAN No. Isueed District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerificationII."VE Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerificationII."VE Previous Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerificationII."VE Passport No. Exp Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerificationII."VE Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerificationII."VE Prev Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerificationII."VE Voter ID No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerificationII."VE IN EMB Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerificationII."VE IN EMB Reg No. Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerificationII."VE Gender" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, IFFVerificationII."VE Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerificationII."VE Grand Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerificationII."VE Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerificationII."VE Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerificationII."VE Mother's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerificationII."VE Address Type" + Seperator); //VE address1 Type
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerificationII."VE Address Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerificationII."VE Address Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerificationII."VE Address Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerificationII."VE Address District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerificationII."VE Address P.O. Box" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerificationII."VE Address Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerificationII."VE Telephone No. 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerificationII."VE Telephone No. 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerificationII."VE Mobile No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerificationII."VE Fax 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerificationII."VE Fax 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerificationII."VE Email" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerificationII.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 49, '');
                            TempCSVBuffer.InsertEntry(lineNo, 50, '');
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerificationII.NEXT = 0;
                //VS Ends Here

                //VR Starts Here

                IFFVerificationII.RESET;
                IFFVerificationII.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                IF IFFVerificationII.FINDSET THEN
                    REPEAT
                        IF IFFVerificationII.Type = IFFVerificationII.Type::VR THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerificationII."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerificationII."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerificationII."Customer Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, '');//Relationship Entity type
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerificationII."Nature of Relationship" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerificationII."VR Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerificationII."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerificationII."VR DOB/Date of Reg" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerificationII."VR BE Comp Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerificationII."VR BE Comp Reg No. Issued Auth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerificationII."VR Indv. Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerificationII."VR Entity's Prev. Citizen No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, FORMAT(IFFVerificationII."VR Entity CitizenNo IssueDate") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerificationII."VR Entity CitizenNo IssueDistr" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerificationII."VRE PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerificationII."VRE Prev PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerificationII."VRE PAN No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerificationII."VRE BE PAN issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerificationII."VRE Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerificationII."VRE Previous Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerificationII."VRE Passport No. Exp Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerificationII."VRE Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerificationII."VRE Prev. Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerificationII."VRE Voter ID No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerificationII."VRE IN EMB Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerificationII."VRE IN EMB Reg Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerificationII."VR Gender" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, FORMAT(IFFVerificationII."VR Percentage of Control") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerificationII."VR Date of Leaving" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerificationII."VR Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerificationII."VR Grand Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerificationII."VR Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerificationII."VR Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerificationII."VR Mother's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerificationII."VR Address Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerificationII."VR Address Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerificationII."VR Address Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerificationII."VR Address Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerificationII."VR District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerificationII."VR PO BOX" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerificationII."VR Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerificationII."VR Telephone No.1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerificationII."VR Telephone No.2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerificationII."VR Mobile No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerificationII."VR Fax 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerificationII."VR Fax 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 49, IFFVerificationII."VR Email" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 50, IFFVerificationII.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerificationII.NEXT = 0;
            //VR Ends Here
            UNTIL LoanHeader.NEXT = 0;

        //count loan files
        CLEAR(count);
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE(Type, IFFVerficationI.Type::CF);
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        count += 1;
                    UNTIL IFFVerficationI.NEXT = 0;
            UNTIL LoanHeader.NEXT = 0;
        //count

        //TL Starts Here
        IFFVerificationII.RESET;
        IFFVerificationII.SETRANGE(IFFVerificationII.Type, IFFVerificationII.Type::TL);
        IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Commercial);
        //IFFVerificationII.SETFILTER(Type,'%1',IFFVerificationII.Type::TL);
        IF IFFVerificationII.FINDFIRST THEN BEGIN
            //IF IFFVerificationII.Type = IFFVerificationII.Type::TL THEN BEGIN
            lineNo += 1;
            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Segment Identifier" + Seperator);
            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
            TempCSVBuffer.InsertEntry(lineNo, 3, FORMAT(count));
            TempCSVBuffer.InsertEntry(lineNo, 4, '');
            TempCSVBuffer.InsertEntry(lineNo, 5, '');
            TempCSVBuffer.InsertEntry(lineNo, 6, '');
            TempCSVBuffer.InsertEntry(lineNo, 7, '');
            TempCSVBuffer.InsertEntry(lineNo, 8, '');
            TempCSVBuffer.InsertEntry(lineNo, 9, '');
            TempCSVBuffer.InsertEntry(lineNo, 10, '');
            TempCSVBuffer.InsertEntry(lineNo, 11, '');
            TempCSVBuffer.InsertEntry(lineNo, 12, '');
            TempCSVBuffer.InsertEntry(lineNo, 13, '');
            TempCSVBuffer.InsertEntry(lineNo, 14, '');
            TempCSVBuffer.InsertEntry(lineNo, 15, '');
            TempCSVBuffer.InsertEntry(lineNo, 16, '');
            TempCSVBuffer.InsertEntry(lineNo, 17, '');
            TempCSVBuffer.InsertEntry(lineNo, 18, '');
            TempCSVBuffer.InsertEntry(lineNo, 19, '');
            TempCSVBuffer.InsertEntry(lineNo, 20, '');
            TempCSVBuffer.InsertEntry(lineNo, 21, '');
            TempCSVBuffer.InsertEntry(lineNo, 22, '');
            TempCSVBuffer.InsertEntry(lineNo, 23, '');
            TempCSVBuffer.InsertEntry(lineNo, 24, '');
            TempCSVBuffer.InsertEntry(lineNo, 25, '');
            TempCSVBuffer.InsertEntry(lineNo, 26, '');
            TempCSVBuffer.InsertEntry(lineNo, 27, '');
            TempCSVBuffer.InsertEntry(lineNo, 28, '');
            TempCSVBuffer.InsertEntry(lineNo, 29, '');
            TempCSVBuffer.InsertEntry(lineNo, 30, '');
            TempCSVBuffer.InsertEntry(lineNo, 31, '');
            TempCSVBuffer.InsertEntry(lineNo, 32, '');
            TempCSVBuffer.InsertEntry(lineNo, 33, '');
            TempCSVBuffer.InsertEntry(lineNo, 34, '');
            TempCSVBuffer.InsertEntry(lineNo, 35, '');
            TempCSVBuffer.InsertEntry(lineNo, 36, '');
            TempCSVBuffer.InsertEntry(lineNo, 37, '');
            TempCSVBuffer.InsertEntry(lineNo, 38, '');
            TempCSVBuffer.InsertEntry(lineNo, 39, '');
            TempCSVBuffer.InsertEntry(lineNo, 40, '');
            TempCSVBuffer.InsertEntry(lineNo, 41, '');
            TempCSVBuffer.InsertEntry(lineNo, 42, '');
            TempCSVBuffer.InsertEntry(lineNo, 43, '');
            TempCSVBuffer.InsertEntry(lineNo, 44, '');
            TempCSVBuffer.InsertEntry(lineNo, 45, '');
            TempCSVBuffer.InsertEntry(lineNo, 46, '');
            TempCSVBuffer.InsertEntry(lineNo, 47, '');
            TempCSVBuffer.InsertEntry(lineNo, 48, '');
            TempCSVBuffer.InsertEntry(lineNo, 49, '');
            TempCSVBuffer.InsertEntry(lineNo, 50, '');
            TempCSVBuffer.InsertEntry(lineNo, 51, '');
            TempCSVBuffer.InsertEntry(lineNo, 52, '');
            TempCSVBuffer.InsertEntry(lineNo, 53, '');
            TempCSVBuffer.InsertEntry(lineNo, 54, '');
            TempCSVBuffer.InsertEntry(lineNo, 55, '');
        END;


        //TL Ends Here
        KSKLSetup.GET;
        filename := KSKLSetup."Identification Number" + '-COM-' + dateConversionFileName(TODAY) + '-' + timeConversion(TIME);
        finalPathName := KSKLSetup."File Path" + '\' + filename;

        TempCSVBuffer.SaveData(finalPathName + '.csv', '');


        varOldfile := finalPathName + '.csv';
        varNewfile := finalPathName + '.dlt';
        //22
        New := RENAME(varOldfile, varNewfile);
        MESSAGE('done');
        TempCSVBuffer.DELETEALL;

    end;

    local procedure removeComma(FieldVal: Text): Text
    begin
        IF FieldVal <> '' THEN
            EXIT(DELCHR(FieldVal, '=', ','));
    end;

    local procedure removeWhiteSpace(fieldVal: Text): Text
    begin
        IF fieldVal = '' THEN
            EXIT(DELCHR(fieldVal, '=', ' '));

        //For Consumer
    end;

    local procedure insertAndUpdateHDLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                CLEAR(IFFVerification1);
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::HD);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                    // IFFVerification1.SETFILTER(IFFVerification1."Last Modified Date",'<=%1',LoanHeader."Last Modified Date");
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateHDConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::HD);
                        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier HD");
                        insertAndUpdateHDConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateCFLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        LoanLine1: Record "33020063";
        noInstallOverdue: Integer;
        Amt30: Decimal;
        Amt60: Decimal;
        Amt90: Decimal;
        Amt120: Decimal;
        Amt150: Decimal;
        Amt180: Decimal;
        Amt180more: Decimal;
        LoanLineDPD: Record "33020063";
        DPDDay: Integer;
        LLForPrecdDate: Record "33020063";
        PaymentLine: Record "33020072";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                LoanHeader.CALCFIELDS("Date to Clear Loan");
                CLEAR(IFFVerification1);
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::CF);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateCFConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IF LoanHeader."Loan Amount" > Customer."Customer Credit Limit" THEN
                            ERROR('Customer Credit Facilty Sanction Amount not less than Customer Credit Limit.');
                        IF (LoanHeader."Credit Facility Status" = '003') OR (LoanHeader."Credit Facility Status" = '004') THEN
                            LoanHeader.TESTFIELD("Reason for Closure");
                        IF LoanHeader."Reason for Closure" <> '' THEN
                            LoanHeader.TESTFIELD("Closed Date"); //credit facilty closing date
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No."); //Credit Facilty No.
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::CF);
                        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier CF");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                        IFFVerification1.VALIDATE(IFFVerification1."Prev Data Prov ID No.", KSKLSetup."Prev Identification Number");
                        insertAndUpdateCFConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateCHLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Payment Dealy History Flag" = KSKLSetup."Skiping Payment Flag" THEN BEGIN
                    Customer.GET(LoanHeader."Customer No.");
                    IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                        LoanLine.RESET;
                        LoanLine.SETRANGE(LoanLine."Loan No.", LoanHeader."Loan No.");
                        LoanLine.SETRANGE(LoanLine."Line Cleared", FALSE);
                        IF LoanLine.FINDFIRST THEN;
                        IFFVerification1.RESET;
                        IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::CH);
                        IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                        //IFFVerification1.SETFILTER(IFFVerification1."Last Modified Date",'<=%1',LoanHeader."Last Modified Date");
                        IF IFFVerification1.FINDFIRST THEN BEGIN
                            insertAndUpdateCHConsumer(IFFVerification1, LoanHeader);
                            IFFVerification1.MODIFY(TRUE);
                        END ELSE BEGIN
                            IFFVerification1.INIT;
                            IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                            IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::CH);
                            IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier CH");
                            IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                            IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");// not  found
                            insertAndUpdateCHConsumer(IFFVerification1, LoanHeader);
                            IFFVerification1.INSERT(TRUE);
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateCSLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                CLEAR(IFFVerification1);
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::CS);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                    //IFFVerification1.SETFILTER(IFFVerification1."Last Modified Date",'<=%1',LoanHeader."Last Modified Date");
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateCSConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::CS);
                        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier CS");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
                        insertAndUpdateCSConsumer(IFFVerification1, LoanHeader);

                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateESLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::ES);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateESConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::ES);
                        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier ES");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");
                        insertAndUpdateESConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateRSLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        //LoanHeader.SETRANGE("Loan No.",'LO-000340');
        IF LoanHeader.FINDSET THEN
            REPEAT
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                    IFFVerification1.RESET;
                    IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                    IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::RS);
                    IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                    IF IFFVerification1.FINDFIRST THEN BEGIN
                        insertAndUpdateRSConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.MODIFY(TRUE);

                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                        IFFVerification1.INIT;
                        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::RS);
                        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier RS");
                        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                        //iffverf2 shown
                        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
                        insertAndUpdateRSConsumer(IFFVerification1, LoanHeader);
                        IFFVerification1.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateBRLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
        CusRel: Record "33019804";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                //CLEAR(IFFVerification1);
                Customer.GET(LoanHeader."Customer No.");
                IF CusRel.GET(Customer."Related Entity Number") THEN;
                IF CusRel."Has BR" THEN BEGIN
                    IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                        IFFVerification1.RESET;
                        IFFVerification1.SETRANGE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                        IFFVerification1.SETRANGE(IFFVerification1.Type, IFFVerification1.Type::BR);
                        IFFVerification1.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                        IF IFFVerification1.FINDFIRST THEN BEGIN
                            insertAndUpdateBRConsumer(IFFVerification1, LoanHeader);

                            IFFVerification1.MODIFY(TRUE);
                        END ELSE BEGIN
                            Customer.GET(LoanHeader."Customer No.");
                            IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                            IFFVerification1.INIT;
                            IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
                            IFFVerification1.VALIDATE(IFFVerification1.Type, IFFVerification1.Type::BR);
                            IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier BR");
                            IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
                            IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
                            insertAndUpdateBRConsumer(IFFVerification1, LoanHeader);

                            IFFVerification1.INSERT(TRUE);
                        END;
                    END;
                END;

            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateSSLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN

                    CLEAR(IFFVerification2);
                    Customer.GET(LoanHeader."Customer No.");
                    IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                    // IF CustomerRelatedEntity."Security Valuator Type" <> KSKLSetup."Skip VR and VS" THEN BEGIN
                    IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                        IFFVerification2.RESET;
                        IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                        IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::SS);
                        IFFVerification2.SETRANGE("File Type", IFFVerification2."File Type"::Consumer);
                        // IFFVerification2.SETFILTER(IFFVerification2."Last Modified Date",'<=%1',LoanHeader."Last Modified Date");
                        IF IFFVerification2.FINDFIRST THEN BEGIN

                            insertAndUpdateSSConsumer(IFFVerification2, LoanHeader);


                            IFFVerification2.MODIFY(TRUE);
                        END ELSE BEGIN
                            Customer.GET(LoanHeader."Customer No.");
                            IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                            IFFVerification2.INIT;
                            IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                            IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::SS);
                            IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier SS");
                            IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
                            IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");// not found
                            IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");
                            insertAndUpdateSSConsumer(IFFVerification2, LoanHeader);


                            IFFVerification2.INSERT(TRUE);
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateVSLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN//3/20/2023

                    Customer.GET(LoanHeader."Customer No.");
                    IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                    IF CustomerRelatedEntity."Security Valuator Type" <> KSKLSetup."Skip VR and VS" THEN BEGIN//so keep 001

                        IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                            IFFVerification2.RESET;
                            IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                            IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::VS);
                            IFFVerification2.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                            IF IFFVerification2.FINDFIRST THEN BEGIN
                                insertAndUpdateVSConsumer(IFFVerification2, LoanHeader, CustomerRelatedEntity);
                                IFFVerification2.MODIFY(TRUE);
                            END ELSE BEGIN
                                Customer.GET(LoanHeader."Customer No.");
                                IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                                IFFVerification2.INIT;
                                IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                                IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::VS);
                                IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier VS");
                                IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
                                IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");
                                IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");
                                insertAndUpdateVSConsumer(IFFVerification2, LoanHeader, CustomerRelatedEntity);

                                IFFVerification2.INSERT(TRUE);
                            END;
                        END;
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateVRLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN//3/20/2023

                    CLEAR(IFFVerification2);
                    Customer.GET(LoanHeader."Customer No.");
                    IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                    IF CustomerRelatedEntity."Security Valuator Type" <> KSKLSetup."Skip VR and VS" THEN BEGIN//so keep 001
                        IF CustomerRelatedEntity."Valuator Entity Type" <> '001' THEN BEGIN //hardcoded
                            IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                                IFFVerification2.RESET;
                                IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                                IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::VR);
                                IFFVerification2.SETRANGE("File Type", IFFVerification2."File Type"::Consumer);
                                //IFFVerification2.SETFILTER(IFFVerification2."Last Modified Date",'<=%1',LoanHeader."Last Modified Date");
                                IF IFFVerification2.FINDFIRST THEN BEGIN
                                    insertAndUpdateVRConsumer(IFFVerification2, LoanHeader);
                                    IFFVerification2.MODIFY(TRUE);
                                END ELSE BEGIN
                                    Customer.GET(LoanHeader."Customer No.");
                                    IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
                                    IFFVerification2.INIT;
                                    IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                                    IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::VR);
                                    IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier VR");
                                    IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
                                    IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
                                    IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");//not found
                                    insertAndUpdateVRConsumer(IFFVerification2, LoanHeader);
                                    IFFVerification2.INSERT(TRUE);
                                END;
                            END;
                        END;

                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    local procedure insertAndUpdateTLLoanwiseForConsumer()
    var
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                CLEAR(IFFVerification2);
                Customer.GET(LoanHeader."Customer No.");
                IF Customer."Nature of Data" = KSKLSetup."Nature of Data(Consumer)" THEN BEGIN
                    IFFVerification2.RESET;
                    IFFVerification2.SETRANGE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                    IFFVerification2.SETRANGE(IFFVerification2.Type, IFFVerification2.Type::TL);
                    IFFVerification2.SETRANGE("File Type", IFFVerification1."File Type"::Consumer);
                    IF IFFVerification2.FINDFIRST THEN BEGIN
                        insertAndUpdateTLConsumer(IFFVerification2, LoanHeader);
                        IFFVerification2.MODIFY(TRUE);
                    END ELSE BEGIN
                        Customer.GET(LoanHeader."Customer No.");
                        IFFVerification2.INIT;
                        IFFVerification2.VALIDATE(IFFVerification2."Loan No.", LoanHeader."Loan No.");
                        IFFVerification2.VALIDATE(IFFVerification2.Type, IFFVerification2.Type::TL);
                        IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier TL");
                        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");//not found
                        insertAndUpdateTLConsumer(IFFVerification2, LoanHeader);
                        IFFVerification2.INSERT(TRUE);
                    END;
                END;
            UNTIL LoanHeader.NEXT = 0;
        COMMIT;
    end;

    [Scope('Internal')]
    procedure exportHeaderFileForConsumer()
    var
        lineNo: Integer;
        TempCSVBuffer: Record "1234" temporary;
        IFFVerficationI: Record "33019802";
        filePath: Text;
        HDLineNo: Integer;
        IFFVerificationII: Record "33019803";
        Seperator: Text;
        varOldfile: Text;
        varNewfile: Text;
        New: Boolean;
        LoanHeader: Record "33020062";
        KSKLSetup: Record "33019801";
        filename: Text;
        finalPathName: Text;
        "count": Integer;
    begin
        KSKLSetup.GET;//2
        lineNo := 0; //please work on this code
        Seperator := '|';
        //HD starts Here
        IFFVerficationI.RESET;
        IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
        IF IFFVerficationI.FINDFIRST THEN
            IF IFFVerficationI.Type = IFFVerficationI.Type::HD THEN BEGIN //HD Begins
                lineNo += 1;
                TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Consumer Segment Identifier" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Reporting Date" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Reporting Time" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Date of Prep File" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Nature of Data" + Seperator);
                TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."IFF Version ID(Consumer)");
                TempCSVBuffer.InsertEntry(lineNo, 8, '');
                TempCSVBuffer.InsertEntry(lineNo, 9, '');
                TempCSVBuffer.InsertEntry(lineNo, 10, '');
                TempCSVBuffer.InsertEntry(lineNo, 11, '');
                TempCSVBuffer.InsertEntry(lineNo, 12, '');
                TempCSVBuffer.InsertEntry(lineNo, 13, '');
                TempCSVBuffer.InsertEntry(lineNo, 14, '');
                TempCSVBuffer.InsertEntry(lineNo, 15, '');
                TempCSVBuffer.InsertEntry(lineNo, 16, '');
                TempCSVBuffer.InsertEntry(lineNo, 17, '');
                TempCSVBuffer.InsertEntry(lineNo, 18, '');
                TempCSVBuffer.InsertEntry(lineNo, 19, '');
                TempCSVBuffer.InsertEntry(lineNo, 20, '');
                TempCSVBuffer.InsertEntry(lineNo, 21, '');
                TempCSVBuffer.InsertEntry(lineNo, 22, '');
                TempCSVBuffer.InsertEntry(lineNo, 23, '');
                TempCSVBuffer.InsertEntry(lineNo, 24, '');
                TempCSVBuffer.InsertEntry(lineNo, 25, '');
                TempCSVBuffer.InsertEntry(lineNo, 26, '');
                TempCSVBuffer.InsertEntry(lineNo, 27, '');
                TempCSVBuffer.InsertEntry(lineNo, 28, '');
                TempCSVBuffer.InsertEntry(lineNo, 29, '');
                TempCSVBuffer.InsertEntry(lineNo, 30, '');
                TempCSVBuffer.InsertEntry(lineNo, 31, '');
                TempCSVBuffer.InsertEntry(lineNo, 32, '');
                TempCSVBuffer.InsertEntry(lineNo, 33, '');
                TempCSVBuffer.InsertEntry(lineNo, 34, '');
                TempCSVBuffer.InsertEntry(lineNo, 35, '');
                TempCSVBuffer.InsertEntry(lineNo, 36, '');
                TempCSVBuffer.InsertEntry(lineNo, 37, '');
                TempCSVBuffer.InsertEntry(lineNo, 38, '');
                TempCSVBuffer.InsertEntry(lineNo, 39, '');
                TempCSVBuffer.InsertEntry(lineNo, 40, '');
                TempCSVBuffer.InsertEntry(lineNo, 41, '');
                TempCSVBuffer.InsertEntry(lineNo, 42, '');
                TempCSVBuffer.InsertEntry(lineNo, 43, '');
                TempCSVBuffer.InsertEntry(lineNo, 44, '');
                TempCSVBuffer.InsertEntry(lineNo, 45, '');
                TempCSVBuffer.InsertEntry(lineNo, 46, '');
                TempCSVBuffer.InsertEntry(lineNo, 47, '');
                TempCSVBuffer.InsertEntry(lineNo, 48, '');
                TempCSVBuffer.InsertEntry(lineNo, 49, '');
                TempCSVBuffer.InsertEntry(lineNo, 50, '');
                TempCSVBuffer.InsertEntry(lineNo, 51, '');
                TempCSVBuffer.InsertEntry(lineNo, 52, '');
                TempCSVBuffer.InsertEntry(lineNo, 53, '');
                TempCSVBuffer.InsertEntry(lineNo, 54, '');
                TempCSVBuffer.InsertEntry(lineNo, 55, '');
            END;


        //HD Ends Here

        //CF Starts Here
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT //loan wise //20
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::CF THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Consumer Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Prev Data Prov Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Prev Data Prov Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Prev Loan No" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."Credit Facility Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Purpose of Credit Facility" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."Ownership Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, FORMAT(IFFVerficationI."Credit Facilty Open Date") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, removeComma(FORMAT(IFFVerficationI."Customer Credit Limit")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, removeComma(FORMAT(IFFVerficationI."Credit Facility Sanction Amt")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."Credit Facilty Sanction Curr" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."Disbursement Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, removeComma(FORMAT(IFFVerficationI."Disbursement Amount")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI."Natural Credit Exp Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."Repayment Frequency" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, FORMAT(IFFVerficationI."No. of Installments") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, removeComma(FORMAT(IFFVerficationI."Amount of Installment")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."Immediate Preceeding Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, removeComma(FORMAT(IFFVerficationI."Total Outstanding Balance")) + Seperator);
                            IF IFFVerficationI."Highest Credit Usage" <> 0 THEN
                                TempCSVBuffer.InsertEntry(lineNo, 23, FORMAT(IFFVerficationI."Highest Credit Usage") + Seperator)
                            ELSE
                                TempCSVBuffer.InsertEntry(lineNo, 23, '' + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."Date of Last Repay" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, removeComma(FORMAT(IFFVerficationI."Last Repay Amount")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, FORMAT(IFFVerficationI."Payment Delay Days") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."Payment Delay Indicator" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, FORMAT(IFFVerficationI."Number of days over due") + Seperator); //ok
                            TempCSVBuffer.InsertEntry(lineNo, 29, FORMAT(IFFVerficationI."No of Installments Overdue") + Seperator); //number of payment
                            TempCSVBuffer.InsertEntry(lineNo, 30, removeComma(FORMAT(IFFVerficationI."Amount OverDue")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, removeComma(FORMAT(IFFVerficationI."Amount OverDue 1-30 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, removeComma(FORMAT(IFFVerficationI."Amount OverDue 31-60 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, removeComma(FORMAT(IFFVerficationI."Amount OverDue 61-90 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, removeComma(FORMAT(IFFVerficationI."Amount OverDue 91-120 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, removeComma(FORMAT(IFFVerficationI."Amount OverDue 121-150 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, removeComma(FORMAT(IFFVerficationI."Amount OverDue 151-180 Days")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, removeComma(FORMAT(IFFVerficationI."Amount  Overdue 181 or More")) + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI."Assets Classification" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerficationI."Credit Facility Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerficationI."Credit Facility Closing Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerficationI."Reason for Closure" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerficationI."Security Coverage Flag" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerficationI."Legal Action Taken" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerficationI."Info Update On" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, FORMAT(IFFVerficationI."Time of Update"));
                            TempCSVBuffer.InsertEntry(lineNo, 46, '');
                            TempCSVBuffer.InsertEntry(lineNo, 47, '');
                            TempCSVBuffer.InsertEntry(lineNo, 48, '');
                            TempCSVBuffer.InsertEntry(lineNo, 49, '');
                            TempCSVBuffer.InsertEntry(lineNo, 50, '');
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');//22
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //CF Ends Here

                //CH Starts Here
                IF LoanHeader."Payment Dealy History Flag" = KSKLSetup."Skiping Payment Flag" THEN BEGIN //231
                    IFFVerficationI.RESET;
                    IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                    IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                    IF IFFVerficationI.FINDSET THEN
                        REPEAT
                            IF IFFVerficationI.Type = IFFVerficationI.Type::CH THEN BEGIN
                                lineNo += 1;
                                TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Consumer Segment Identifier" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Date Reported" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Installment Due Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Payment Due Settlment Date" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 8, FORMAT(IFFVerficationI."Payment Delay Days"));
                                TempCSVBuffer.InsertEntry(lineNo, 9, '');
                                TempCSVBuffer.InsertEntry(lineNo, 10, '');
                                TempCSVBuffer.InsertEntry(lineNo, 11, '');
                                TempCSVBuffer.InsertEntry(lineNo, 12, '');
                                TempCSVBuffer.InsertEntry(lineNo, 13, '');
                                TempCSVBuffer.InsertEntry(lineNo, 14, '');
                                TempCSVBuffer.InsertEntry(lineNo, 15, '');
                                TempCSVBuffer.InsertEntry(lineNo, 16, '');
                                TempCSVBuffer.InsertEntry(lineNo, 17, '');
                                TempCSVBuffer.InsertEntry(lineNo, 18, '');
                                TempCSVBuffer.InsertEntry(lineNo, 19, '');
                                TempCSVBuffer.InsertEntry(lineNo, 20, '');
                                TempCSVBuffer.InsertEntry(lineNo, 21, '');
                                TempCSVBuffer.InsertEntry(lineNo, 22, '');
                                TempCSVBuffer.InsertEntry(lineNo, 23, '');
                                TempCSVBuffer.InsertEntry(lineNo, 24, '');
                                TempCSVBuffer.InsertEntry(lineNo, 25, '');
                                TempCSVBuffer.InsertEntry(lineNo, 26, '');
                                TempCSVBuffer.InsertEntry(lineNo, 27, '');
                                TempCSVBuffer.InsertEntry(lineNo, 28, '');
                                TempCSVBuffer.InsertEntry(lineNo, 29, '');
                                TempCSVBuffer.InsertEntry(lineNo, 30, '');
                                TempCSVBuffer.InsertEntry(lineNo, 31, '');
                                TempCSVBuffer.InsertEntry(lineNo, 32, '');
                                TempCSVBuffer.InsertEntry(lineNo, 33, '');
                                TempCSVBuffer.InsertEntry(lineNo, 34, '');
                                TempCSVBuffer.InsertEntry(lineNo, 35, '');
                                TempCSVBuffer.InsertEntry(lineNo, 36, '');
                                TempCSVBuffer.InsertEntry(lineNo, 37, '');
                                TempCSVBuffer.InsertEntry(lineNo, 38, '');
                                TempCSVBuffer.InsertEntry(lineNo, 39, '');
                                TempCSVBuffer.InsertEntry(lineNo, 40, '');
                                TempCSVBuffer.InsertEntry(lineNo, 41, '');
                                TempCSVBuffer.InsertEntry(lineNo, 42, '');
                                TempCSVBuffer.InsertEntry(lineNo, 43, '');
                                TempCSVBuffer.InsertEntry(lineNo, 44, '');
                                TempCSVBuffer.InsertEntry(lineNo, 45, '');
                                TempCSVBuffer.InsertEntry(lineNo, 46, '');
                                TempCSVBuffer.InsertEntry(lineNo, 47, '');
                                TempCSVBuffer.InsertEntry(lineNo, 48, '');
                                TempCSVBuffer.InsertEntry(lineNo, 49, '');
                                TempCSVBuffer.InsertEntry(lineNo, 50, '');
                                TempCSVBuffer.InsertEntry(lineNo, 51, '');
                                TempCSVBuffer.InsertEntry(lineNo, 52, '');
                                TempCSVBuffer.InsertEntry(lineNo, 53, '');
                                TempCSVBuffer.InsertEntry(lineNo, 54, '');
                                TempCSVBuffer.InsertEntry(lineNo, 55, '');
                            END;
                        UNTIL IFFVerficationI.NEXT = 0;
                END;
                //CH Ends Here

                //CS Starts Here
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::CS THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Consumer Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Prev Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Subject Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."Subject Prev Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Citizenship Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."Prev Citizenship Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerficationI."Citizenship Issued Date" + Seperator); //citizenship number issued date
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerficationI."Citizenship Issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerficationI.PAN + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."Previous PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."PAN Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerficationI."PAN Issue District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI.Passport + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."Prev Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerficationI."Passport No. Expiry Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerficationI."Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."Prev Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerficationI."Voter ID no issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerficationI."IN Embassy Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."IN Embasssy Reg No. Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerficationI."Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerficationI."Grand Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerficationI."Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerficationI."Mother Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, IFFVerficationI."Subject Nationality" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerficationI."Marital Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerficationI."Date of Birth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerficationI.Gender + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerficationI."Address1 Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerficationI."Address1 Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerficationI."Address1 Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerficationI."Address1 Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI."Address1 District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerficationI."Address1 PO Box" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerficationI."Address1 Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerficationI."Address 2 Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerficationI."Address 2 Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerficationI."Address 2 Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerficationI."Address 2 Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerficationI."Address 2 District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerficationI."Address 2 Power BOX" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerficationI."Address 2 Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerficationI."Telephone 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 49, IFFVerficationI."Telephone Number 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 50, IFFVerficationI."Mobile Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 51, IFFVerficationI."Business Activity Code" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 52, IFFVerficationI."Fax 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 53, IFFVerficationI.Fax2 + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 54, IFFVerficationI."Email Address" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 55, IFFVerficationI.Group);
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //CS Ends Here

                //ES Starts Here
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No."); //20
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerficationI.FINDFIRST THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::ES THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Consumer Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Employment Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Employer Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."Employement Comm Regd ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Subject Employer Address" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI.Designation + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, FORMAT(IFFVerficationI."Monthly Income"));
                            TempCSVBuffer.InsertEntry(lineNo, 12, '');
                            TempCSVBuffer.InsertEntry(lineNo, 13, '');
                            TempCSVBuffer.InsertEntry(lineNo, 14, '');
                            TempCSVBuffer.InsertEntry(lineNo, 15, '');
                            TempCSVBuffer.InsertEntry(lineNo, 16, '');
                            TempCSVBuffer.InsertEntry(lineNo, 17, '');
                            TempCSVBuffer.InsertEntry(lineNo, 18, '');
                            TempCSVBuffer.InsertEntry(lineNo, 19, '');
                            TempCSVBuffer.InsertEntry(lineNo, 20, '');
                            TempCSVBuffer.InsertEntry(lineNo, 21, '');
                            TempCSVBuffer.InsertEntry(lineNo, 22, '');
                            TempCSVBuffer.InsertEntry(lineNo, 23, '');
                            TempCSVBuffer.InsertEntry(lineNo, 24, '');
                            TempCSVBuffer.InsertEntry(lineNo, 25, '');
                            TempCSVBuffer.InsertEntry(lineNo, 26, '');
                            TempCSVBuffer.InsertEntry(lineNo, 27, '');
                            TempCSVBuffer.InsertEntry(lineNo, 28, '');
                            TempCSVBuffer.InsertEntry(lineNo, 29, '');
                            TempCSVBuffer.InsertEntry(lineNo, 30, '');
                            TempCSVBuffer.InsertEntry(lineNo, 31, '');
                            TempCSVBuffer.InsertEntry(lineNo, 32, '');
                            TempCSVBuffer.InsertEntry(lineNo, 33, '');
                            TempCSVBuffer.InsertEntry(lineNo, 34, '');
                            TempCSVBuffer.InsertEntry(lineNo, 35, '');
                            TempCSVBuffer.InsertEntry(lineNo, 36, '');
                            TempCSVBuffer.InsertEntry(lineNo, 37, '');
                            TempCSVBuffer.InsertEntry(lineNo, 38, '');
                            TempCSVBuffer.InsertEntry(lineNo, 39, '');
                            TempCSVBuffer.InsertEntry(lineNo, 40, '');
                            TempCSVBuffer.InsertEntry(lineNo, 41, '');
                            TempCSVBuffer.InsertEntry(lineNo, 42, '');
                            TempCSVBuffer.InsertEntry(lineNo, 43, '');
                            TempCSVBuffer.InsertEntry(lineNo, 44, '');
                            TempCSVBuffer.InsertEntry(lineNo, 45, '');
                            TempCSVBuffer.InsertEntry(lineNo, 46, '');
                            TempCSVBuffer.InsertEntry(lineNo, 47, '');
                            TempCSVBuffer.InsertEntry(lineNo, 48, '');
                            TempCSVBuffer.InsertEntry(lineNo, 49, '');
                            TempCSVBuffer.InsertEntry(lineNo, 50, '');
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;


                //ES Ends Here

                //RS Starts Here
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No."); //20
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::RS THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Consumer Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."Related Entity Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Nature of Relationship" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."Related Entities Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."Date of Birth Comp Redg" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerficationI."RE Comp Redg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerficationI."RE Comp Reg No. Issued Auth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerficationI."RE Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."RE Prev Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."RE Citizenship No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerficationI."RE Citizen No. Issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI."RE PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."RE Previous PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerficationI."RE PAN No. Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerficationI."RE PAN issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."RE Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerficationI."RE Previous Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerficationI."Passport No. Expiry Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."RE Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerficationI."RE Previous Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerficationI."RE Voter ID No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."IN Embassy Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerficationI."IN Embasssy Reg No. Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, FORMAT(IFFVerficationI."Percentage of Control") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, IFFVerficationI."Guarantee Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerficationI."Date of Leaving" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerficationI."Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerficationI."Grand Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerficationI."Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerficationI."Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerficationI."Mother Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerficationI."Related Indiv Nationality" + Seperator);//Related Entity Nationality...verify
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI."RE Gender" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerficationI."RE Entities Address Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerficationI."RE Address 1 Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerficationI."RE Entities Address Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerficationI."RE Entities Address Line 3" + Seperator); //RE Address1 Line3
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerficationI."RE Entities Address District" + Seperator); // RE Address1 District
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerficationI."RE Entities Address P.O Box No" + Seperator); // RE Address1 PO Box Number
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerficationI."RE Entities Address Country" + Seperator); //RE Address1 Country
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerficationI."RE Entities Telephone No.1" + Seperator); //RE Telephone number1
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerficationI."RE Entities Telephone No.2" + Seperator);// RE Telephone Number 2
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerficationI."Related Indv. Mobile No." + Seperator); // RE Mobile number
                            TempCSVBuffer.InsertEntry(lineNo, 49, IFFVerficationI.Fax1 + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 50, IFFVerficationI.Fax2 + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 51, IFFVerficationI."RE Entities Email Address" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 52, IFFVerficationI.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //RS Ends Here

                //BR Starts Here
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No."); //20
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        IF IFFVerficationI.Type = IFFVerficationI.Type::BR THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerficationI."Consumer Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerficationI."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerficationI."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerficationI."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerficationI."Customer No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerficationI."BR Entity Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerficationI."Nature of Relationship" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerficationI."BR RE Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerficationI."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerficationI."BR RE DOB/Date of Reg" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerficationI."BR RE Comp Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerficationI."BR RE Comp Reg No. Issue Auth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerficationI."BR RE Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerficationI."BR RE Prev. Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerficationI."BR RE Citizen No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerficationI."BR RE Citizen No. Issue Dist" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerficationI."BR RE PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerficationI."BR RE Prev. PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerficationI."BR RE PAN No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerficationI."BR RE PAN Issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerficationI."BR RE Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerficationI."BR RE Previous Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerficationI."BR RE Passport No. Exp Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerficationI."BR RE Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerficationI."BR RE Prev. Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerficationI."BR RE Voter ID No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerficationI."BR Re In Emb Regd No" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerficationI."BR RE IN Emb Reg No. Issue Dat" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerficationI."BR RE Gender" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, FORMAT(IFFVerficationI."BR RE Percentage of control") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerficationI."BR RE Date of Leaving" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerficationI."BR RE Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerficationI."BR RE Grand Father Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerficationI."BR RE Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerficationI."BR RE Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerficationI."BR RE Mother Name" + Seperator);
                            IF IFFVerficationI."BR Entity Type" = '001' THEN BEGIN
                                TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerficationI."BR Nationality" + Seperator);//2/1
                            END;
                            //TempCSVBuffer.InsertEntry(lineNo,37,IFFVerficationI."BR Nationality"+ Seperator);//2/1
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerficationI."BR RE Address Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerficationI."BR RE Address Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerficationI."BR RE Address Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerficationI."BR RE Address Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerficationI."BR RE District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerficationI."BR RE P.O. Box" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerficationI."BR RE Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerficationI."BR RE Telephone No. 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerficationI."BR RE Telephone No. 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerficationI."BR RE Mobile No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerficationI."BR RE Fax 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 49, IFFVerficationI."BR RE Fax2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 50, IFFVerficationI."BR RE Email" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 51, IFFVerficationI.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerficationI.NEXT = 0;
                //BR Ends Here

                //SS Starts Here
                IF LoanHeader."Security Coverage Flag" <> '002' THEN BEGIN
                    IFFVerificationII.RESET;
                    IFFVerificationII.SETRANGE("Loan No.", LoanHeader."Loan No."); //20
                    IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                    IF IFFVerificationII.FINDSET THEN
                        REPEAT
                            IF IFFVerificationII.Type = IFFVerificationII.Type::SS THEN BEGIN
                                lineNo += 1;
                                TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Consumer Segment Identifier" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerificationII."Data Provider Branch ID" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerificationII."Loan No." + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerificationII."Customer Number" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerificationII."Type of Security" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerificationII."Security Ownership Type" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerificationII."Valuator Type" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerificationII."Description of Security" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerificationII."Nature of Charge" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerificationII."Security Coverage Percentage" + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 12, FORMAT(IFFVerificationII."Latest Value of Security") + Seperator);
                                TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerificationII."Date of Latest Valuation");
                                TempCSVBuffer.InsertEntry(lineNo, 14, '');
                                TempCSVBuffer.InsertEntry(lineNo, 15, '');
                                TempCSVBuffer.InsertEntry(lineNo, 16, '');
                                TempCSVBuffer.InsertEntry(lineNo, 17, '');
                                TempCSVBuffer.InsertEntry(lineNo, 18, '');
                                TempCSVBuffer.InsertEntry(lineNo, 19, '');
                                TempCSVBuffer.InsertEntry(lineNo, 20, '');
                                TempCSVBuffer.InsertEntry(lineNo, 21, '');
                                TempCSVBuffer.InsertEntry(lineNo, 22, '');
                                TempCSVBuffer.InsertEntry(lineNo, 23, '');
                                TempCSVBuffer.InsertEntry(lineNo, 24, '');
                                TempCSVBuffer.InsertEntry(lineNo, 25, '');
                                TempCSVBuffer.InsertEntry(lineNo, 26, '');
                                TempCSVBuffer.InsertEntry(lineNo, 27, '');
                                TempCSVBuffer.InsertEntry(lineNo, 28, '');
                                TempCSVBuffer.InsertEntry(lineNo, 29, '');
                                TempCSVBuffer.InsertEntry(lineNo, 30, '');
                                TempCSVBuffer.InsertEntry(lineNo, 31, '');
                                TempCSVBuffer.InsertEntry(lineNo, 32, '');
                                TempCSVBuffer.InsertEntry(lineNo, 33, '');
                                TempCSVBuffer.InsertEntry(lineNo, 34, '');
                                TempCSVBuffer.InsertEntry(lineNo, 35, '');
                                TempCSVBuffer.InsertEntry(lineNo, 36, '');
                                TempCSVBuffer.InsertEntry(lineNo, 37, '');
                                TempCSVBuffer.InsertEntry(lineNo, 38, '');
                                TempCSVBuffer.InsertEntry(lineNo, 39, '');
                                TempCSVBuffer.InsertEntry(lineNo, 40, '');
                                TempCSVBuffer.InsertEntry(lineNo, 41, '');
                                TempCSVBuffer.InsertEntry(lineNo, 42, '');
                                TempCSVBuffer.InsertEntry(lineNo, 43, '');
                                TempCSVBuffer.InsertEntry(lineNo, 44, '');
                                TempCSVBuffer.InsertEntry(lineNo, 45, '');
                                TempCSVBuffer.InsertEntry(lineNo, 46, '');
                                TempCSVBuffer.InsertEntry(lineNo, 47, '');
                                TempCSVBuffer.InsertEntry(lineNo, 48, '');
                                TempCSVBuffer.InsertEntry(lineNo, 49, '');
                                TempCSVBuffer.InsertEntry(lineNo, 50, '');
                                TempCSVBuffer.InsertEntry(lineNo, 51, '');
                                TempCSVBuffer.InsertEntry(lineNo, 52, '');
                                TempCSVBuffer.InsertEntry(lineNo, 53, '');
                                TempCSVBuffer.InsertEntry(lineNo, 54, '');
                                TempCSVBuffer.InsertEntry(lineNo, 55, '');
                            END;
                        UNTIL IFFVerificationII.NEXT = 0;
                END;
                //SS Ends Here

                //VS Starts Here
                IFFVerificationII.RESET;
                IFFVerificationII.SETRANGE("Loan No.", LoanHeader."Loan No."); //20
                IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerificationII.FINDSET THEN
                    REPEAT
                        IF IFFVerificationII.Type = IFFVerificationII.Type::VS THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Consumer Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerificationII."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerificationII."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerificationII."Customer Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerificationII."Previous Customer No" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerificationII."Valuator Entity Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerificationII."Valuator Entity's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerificationII."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerificationII."VE DOB/Comp Reg Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerificationII."VE Comp Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerificationII."VE Comp Reg No. Issue Auth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerificationII."VE Citizenship No" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerificationII."VE Previous Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, IFFVerificationII."VE Citizenship No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerificationII."VE Citizenship No. Issued Dist" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerificationII."VE PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerificationII."VE Prev PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerificationII."VE PAN No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerificationII."VE PAN No. Isueed District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerificationII."VE Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerificationII."VE Previous Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerificationII."VE Passport No. Exp Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerificationII."VE Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerificationII."VE Prev Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerificationII."VE Voter ID No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerificationII."VE IN EMB Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerificationII."VE IN EMB Reg No. Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerificationII."VE Gender" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, IFFVerificationII."VE Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerificationII."VE Grand Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerificationII."VE Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerificationII."VE Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerificationII."VE Mother's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerificationII."VE Address Type" + Seperator); //VE address1 Type
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerificationII."VE Address Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerificationII."VE Address Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerificationII."VE Address Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerificationII."VE Address District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerificationII."VE Address P.O. Box" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerificationII."VE Address Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerificationII."VE Telephone No. 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerificationII."VE Telephone No. 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerificationII."VE Mobile No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerificationII."VE Fax 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerificationII."VE Fax 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerificationII."VE Email" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerificationII.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 49, '');
                            TempCSVBuffer.InsertEntry(lineNo, 50, '');
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');
                        END;
                    UNTIL IFFVerificationII.NEXT = 0;
                //VS Ends Here

                //VR Starts Here

                IFFVerificationII.RESET;
                IFFVerificationII.SETRANGE("Loan No.", LoanHeader."Loan No."); //20
                IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerificationII.FINDSET THEN
                    REPEAT
                        IF IFFVerificationII.Type = IFFVerificationII.Type::VR THEN BEGIN
                            lineNo += 1;
                            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Consumer Segment Identifier" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 3, IFFVerificationII."Data Provider Branch ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 4, IFFVerificationII."Loan No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 5, IFFVerificationII."Customer Number" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 6, IFFVerificationII."Valuator Rltn Entity Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 7, IFFVerificationII."Nature of Relationship" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 8, IFFVerificationII."VR Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 9, IFFVerificationII."Legal Status" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 10, IFFVerificationII."VR DOB/Date of Reg" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 11, IFFVerificationII."VR BE Comp Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 12, IFFVerificationII."VR BE Comp Reg No. Issued Auth" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 13, IFFVerificationII."VR Indv. Citizenship No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 14, IFFVerificationII."VR Entity's Prev. Citizen No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 15, FORMAT(IFFVerificationII."VR Entity CitizenNo IssueDate") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 16, IFFVerificationII."VR Entity CitizenNo IssueDistr" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 17, IFFVerificationII."VRE PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 18, IFFVerificationII."VRE Prev PAN" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 19, IFFVerificationII."VRE PAN No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 20, IFFVerificationII."VRE BE PAN issued District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 21, IFFVerificationII."VRE Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 22, IFFVerificationII."VRE Previous Passport" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 23, IFFVerificationII."VRE Passport No. Exp Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 24, IFFVerificationII."VRE Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 25, IFFVerificationII."VRE Prev. Voter ID" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 26, IFFVerificationII."VRE Voter ID No. Issued Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 27, IFFVerificationII."VRE IN EMB Reg No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 28, IFFVerificationII."VRE IN EMB Reg Issue Date" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 29, IFFVerificationII."VR Gender" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 30, FORMAT(IFFVerificationII."VR Percentage of Control") + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 31, IFFVerificationII."VR Date of Leaving" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 32, IFFVerificationII."VR Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 33, IFFVerificationII."VR Grand Father's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 34, IFFVerificationII."VR Spouse1 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 35, IFFVerificationII."VR Spouse2 Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 36, IFFVerificationII."VR Mother's Name" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 37, IFFVerificationII."VR Address Type" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 38, IFFVerificationII."VR Address Line 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 39, IFFVerificationII."VR Address Line 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 40, IFFVerificationII."VR Address Line 3" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 41, IFFVerificationII."VR District" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 42, IFFVerificationII."VR PO BOX" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 43, IFFVerificationII."VR Country" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 44, IFFVerificationII."VR Telephone No.1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 45, IFFVerificationII."VR Telephone No.2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 46, IFFVerificationII."VR Mobile No." + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 47, IFFVerificationII."VR Fax 1" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 48, IFFVerificationII."VR Fax 2" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 49, IFFVerificationII."VR Email" + Seperator);
                            TempCSVBuffer.InsertEntry(lineNo, 50, IFFVerificationII.Group);
                            TempCSVBuffer.InsertEntry(lineNo, 51, '');
                            TempCSVBuffer.InsertEntry(lineNo, 52, '');
                            TempCSVBuffer.InsertEntry(lineNo, 53, '');
                            TempCSVBuffer.InsertEntry(lineNo, 54, '');
                            TempCSVBuffer.InsertEntry(lineNo, 55, '');

                        END;
                    UNTIL IFFVerificationII.NEXT = 0;
            UNTIL LoanHeader.NEXT = 0;
        //loan wise  //20
        //VR Ends Here
        //count loan files

        //count loan files
        CLEAR(count);
        LoanHeader.RESET;
        LoanHeader.SETRANGE("Loan Disbursed", TRUE);
        IF KSKLSetup."Closed Loan" THEN
            LoanHeader.SETRANGE(Closed, TRUE)
        ELSE
            LoanHeader.SETRANGE(Closed, FALSE);
        LoanHeader.SETRANGE(Rejected, FALSE);
        IF LoanHeader.FINDSET THEN
            REPEAT
                IFFVerficationI.RESET;
                IFFVerficationI.SETRANGE("Loan No.", LoanHeader."Loan No.");
                IFFVerficationI.SETRANGE(Type, IFFVerficationI.Type::CF);
                IFFVerficationI.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
                IF IFFVerficationI.FINDSET THEN
                    REPEAT
                        count += 1;
                    UNTIL IFFVerficationI.NEXT = 0;
            UNTIL LoanHeader.NEXT = 0;
        //count

        //TL Starts Here
        IFFVerificationII.RESET;
        IFFVerificationII.SETRANGE(IFFVerificationII.Type, IFFVerificationII.Type::TL);
        IFFVerificationII.SETRANGE("File Type", IFFVerficationI."File Type"::Consumer);
        IF IFFVerificationII.FINDFIRST THEN BEGIN
            lineNo += 1;
            TempCSVBuffer.InsertEntry(lineNo, 1, IFFVerificationII."Consumer Segment Identifier" + Seperator);
            TempCSVBuffer.InsertEntry(lineNo, 2, IFFVerificationII."Data Prov Identification No." + Seperator);
            TempCSVBuffer.InsertEntry(lineNo, 3, FORMAT(count));
            TempCSVBuffer.InsertEntry(lineNo, 4, '');
            TempCSVBuffer.InsertEntry(lineNo, 5, '');
            TempCSVBuffer.InsertEntry(lineNo, 6, '');
            TempCSVBuffer.InsertEntry(lineNo, 7, '');
            TempCSVBuffer.InsertEntry(lineNo, 8, '');
            TempCSVBuffer.InsertEntry(lineNo, 9, '');
            TempCSVBuffer.InsertEntry(lineNo, 10, '');
            TempCSVBuffer.InsertEntry(lineNo, 11, '');
            TempCSVBuffer.InsertEntry(lineNo, 12, '');
            TempCSVBuffer.InsertEntry(lineNo, 13, '');
            TempCSVBuffer.InsertEntry(lineNo, 14, '');
            TempCSVBuffer.InsertEntry(lineNo, 15, '');
            TempCSVBuffer.InsertEntry(lineNo, 16, '');
            TempCSVBuffer.InsertEntry(lineNo, 17, '');
            TempCSVBuffer.InsertEntry(lineNo, 18, '');
            TempCSVBuffer.InsertEntry(lineNo, 19, '');
            TempCSVBuffer.InsertEntry(lineNo, 20, '');
            TempCSVBuffer.InsertEntry(lineNo, 21, '');
            TempCSVBuffer.InsertEntry(lineNo, 22, '');
            TempCSVBuffer.InsertEntry(lineNo, 23, '');
            TempCSVBuffer.InsertEntry(lineNo, 24, '');
            TempCSVBuffer.InsertEntry(lineNo, 25, '');
            TempCSVBuffer.InsertEntry(lineNo, 26, '');
            TempCSVBuffer.InsertEntry(lineNo, 27, '');
            TempCSVBuffer.InsertEntry(lineNo, 28, '');
            TempCSVBuffer.InsertEntry(lineNo, 29, '');
            TempCSVBuffer.InsertEntry(lineNo, 30, '');
            TempCSVBuffer.InsertEntry(lineNo, 31, '');
            TempCSVBuffer.InsertEntry(lineNo, 32, '');
            TempCSVBuffer.InsertEntry(lineNo, 33, '');
            TempCSVBuffer.InsertEntry(lineNo, 34, '');
            TempCSVBuffer.InsertEntry(lineNo, 35, '');
            TempCSVBuffer.InsertEntry(lineNo, 36, '');
            TempCSVBuffer.InsertEntry(lineNo, 37, '');
            TempCSVBuffer.InsertEntry(lineNo, 38, '');
            TempCSVBuffer.InsertEntry(lineNo, 39, '');
            TempCSVBuffer.InsertEntry(lineNo, 40, '');
            TempCSVBuffer.InsertEntry(lineNo, 41, '');
            TempCSVBuffer.InsertEntry(lineNo, 42, '');
            TempCSVBuffer.InsertEntry(lineNo, 43, '');
            TempCSVBuffer.InsertEntry(lineNo, 44, '');
            TempCSVBuffer.InsertEntry(lineNo, 45, '');
            TempCSVBuffer.InsertEntry(lineNo, 46, '');
            TempCSVBuffer.InsertEntry(lineNo, 47, '');
            TempCSVBuffer.InsertEntry(lineNo, 48, '');
            TempCSVBuffer.InsertEntry(lineNo, 49, '');
            TempCSVBuffer.InsertEntry(lineNo, 50, '');
            TempCSVBuffer.InsertEntry(lineNo, 51, '');
            TempCSVBuffer.InsertEntry(lineNo, 52, '');
            TempCSVBuffer.InsertEntry(lineNo, 53, '');
            TempCSVBuffer.InsertEntry(lineNo, 54, '');
            TempCSVBuffer.InsertEntry(lineNo, 55, '');
        END;


        //TL Ends Here

        KSKLSetup.GET;
        filename := KSKLSetup."Identification Number" + '-CON-' + dateConversionFileName(TODAY) + '-' + timeConversion(TIME);
        finalPathName := KSKLSetup."File Path" + '\' + filename;
        //TempCSVBuffer.SaveData('C:\Users\agile\Desktop\ExportIFFVer3.csv','');
        TempCSVBuffer.SaveData(finalPathName + '.csv', '');

        //varOldfile:='C:\Users\dynamic\Desktop\ExportIFFVer1.csv';
        //varNewfile:='C:\Users\dynamic\Desktop\ExportIFFVer2.dlt';
        varOldfile := finalPathName + '.csv';
        varNewfile := finalPathName + '.dlt';
        New := RENAME(varOldfile, varNewfile);
        MESSAGE('done');
        TempCSVBuffer.DELETEALL;
    end;

    [Scope('Internal')]
    procedure showMandatory(LoanNo: Code[20])
    var
        KSKLSetup: Record "33019801";
        Customer: Record "18";
        LoanHeader: Record "33020062";
        LoanLine: Record "33020063";
        CustomerRelatedEntity: Record "33019804";
    begin
        LoanHeader.GET(LoanNo);
        LoanHeader.TESTFIELD("Customer No.");
        LoanHeader.TESTFIELD("Credit Facility Sanction Curr");
        LoanHeader.TESTFIELD("Credit Facility Type");
        LoanHeader.TESTFIELD("Ownership Type");
        LoanHeader.TESTFIELD("Purpose of Credit Facility");
        LoanHeader.TESTFIELD("Credit Facility Status");
        LoanHeader.TESTFIELD("Payment Receipt Date");
        //LoanHeader.SETRANGE("Customer No.",Customer."No.");
        IF Customer.GET(LoanHeader."Customer No.") THEN BEGIN
            Customer.TESTFIELD("Citizenship No.");
            Customer.TESTFIELD("Citizenship Issued District");
            Customer.TESTFIELD("Address Type");
            Customer.TESTFIELD("Address 1 Line 1");
            Customer.TESTFIELD("Address District");
            Customer.TESTFIELD("Address 2 Type");
            Customer.TESTFIELD("Address 2 Line 1");
            Customer.TESTFIELD("Address 2 District");
            Customer.TESTFIELD("Subject Name");
            Customer.TESTFIELD("Subject Nationality");
            Customer.TESTFIELD("Fathers Name");
            IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN BEGIN
                CustomerRelatedEntity.TESTFIELD("Related Entities Name");
                CustomerRelatedEntity.TESTFIELD("Related Entities Type");
                CustomerRelatedEntity.TESTFIELD("RE Entities Address Type");
                CustomerRelatedEntity.TESTFIELD("RE Entities Address Line 1");
                CustomerRelatedEntity.TESTFIELD("RE Entities Address District");
                CustomerRelatedEntity.TESTFIELD("Nature of Relationship");
                CustomerRelatedEntity.TESTFIELD("BR RE Name");
                CustomerRelatedEntity.TESTFIELD("BR RE DOB/Date of Regd");
                CustomerRelatedEntity.TESTFIELD("BR RE Address Type");
                CustomerRelatedEntity.TESTFIELD("BR RE Address Line 1");
                CustomerRelatedEntity.TESTFIELD("BR RE District");
                CustomerRelatedEntity.TESTFIELD("Valuator Entity Type");
                CustomerRelatedEntity.TESTFIELD("Valuator Entities Name");
                CustomerRelatedEntity.TESTFIELD("VE DOB/Comp Regd Date");
                CustomerRelatedEntity.TESTFIELD("VE Address Type");
                CustomerRelatedEntity.TESTFIELD("VE Address Line1");
                CustomerRelatedEntity.TESTFIELD("VE Address District");
                CustomerRelatedEntity.TESTFIELD("VR Name");
                CustomerRelatedEntity.TESTFIELD("VR Address Type");
                CustomerRelatedEntity.TESTFIELD("VR Address Line1");
                CustomerRelatedEntity.TESTFIELD("VR District");
            END;
        END;


        //customer.GET(loanheader."Customer No.");
    end;

    [Scope('Internal')]
    procedure dateConversionFileName(date: Date): Text
    var
        day: Integer;
        month: Integer;
        year: Integer;
        montxt: Text;
        finalmon: Text;
    begin
        IF date = 0D THEN
            EXIT;
        day := DATE2DMY(date, 1);
        month := DATE2DMY(date, 2);
        year := DATE2DMY(date, 3);

        CASE month OF
            1:
                montxt := 'JAN';
            2:
                montxt := 'FEB';
            3:
                montxt := 'MAR';
            4:
                montxt := 'APR';
            5:
                montxt := 'MAY';
            6:
                montxt := 'JUN';
            7:
                montxt := 'JUL';
            8:
                montxt := 'AUG';
            9:
                montxt := 'SEPT';
            10:
                montxt := 'OCT';
            11:
                montxt := 'NOV';
            12:
                montxt := 'DEC';
        END;


        IF day <= 9 THEN
            finalmon := '0' + FORMAT(day) + montxt + FORMAT(year)
        ELSE
            finalmon := FORMAT(day) + montxt + FORMAT(year);

        EXIT(finalmon);
    end;

    [Scope('Internal')]
    procedure EnglishToNepaliDateConversion(Date: Date): Text
    var
        EngNepDate: Record "33020302";
        NepaliDate: Text;
    begin
        //EngNepDate.RESET;
        //EngNepDate.SETRANGE("English Date",Date);
        //IF EngNepDate.FINDFIRST THEN BEGIN
        //NepaliDate:=EngNepDate.getNepaliDate(Date);
        //END
        // EXIT(NepaliDate);
    end;

    [Scope('Internal')]
    procedure checkNepaliDate(DateText: Text): Text
    var
        firstfour: Text;
        sixthAndSeventh: Text;
        NineTen: Text;
    begin
        IF DateText <> '' THEN BEGIN
            firstfour := COPYSTR(DateText, 1, 4);
            sixthAndSeventh := COPYSTR(DateText, 6, 7);
            NineTen := COPYSTR(DateText, 9, 10);

            /*IF (STRPOS(sixthAndSeventh,'-')  < 2) OR (STRPOS(NineTen,'-')  < 2) THEN
              ERROR('Date must be YYYY-MM-DD');
              */
        END;
        EXIT(DateText);

    end;

    local procedure "**********************make common function for insert and update ******************"()
    begin
    end;

    local procedure insertAndUpdateHDCommercial(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier HD");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Reporting Date", dateConversion(TODAY));
        IFFVerification1.VALIDATE(IFFVerification1."Reporting Time", timeConversion(TIME));
        IFFVerification1.VALIDATE(IFFVerification1."Date of Prep File", dateConversion(TODAY));
        IFFVerification1.VALIDATE(IFFVerification1."Nature of Data", FORMAT(KSKLSetup."Nature of Data(Commercial)"));
        IFFVerification1.VALIDATE(IFFVerification1."IFF Version ID(Commercial)", FORMAT(KSKLSetup."IFF Version ID(Commercial)"));
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
    end;

    local procedure insertAndUpdateCFCommercial(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        LoanLine1: Record "33020063";
        noInstallOverdue: Integer;
        Amt30: Decimal;
        Amt60: Decimal;
        Amt90: Decimal;
        Amt120: Decimal;
        Amt150: Decimal;
        Amt180: Decimal;
        Amt180more: Decimal;
        LoanLineDPD: Record "33020063";
        DPDDay: Integer;
        PaymentLine: Record "33020072";
        LLForPrecdDate: Record "33020063";
        PDDLoanLine: Record "33020063";
        PDDLoanLine1: Record "33020063";
        amtDone: Boolean;
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IF LoanHeader."Loan Amount" > Customer."Customer Credit Limit" THEN
            ERROR('Customer Credit Facilty Sanction Amount not less than Customer Credit Limit.');
        IF (LoanHeader."Credit Facility Status" = '003') OR (LoanHeader."Credit Facility Status" = '004') THEN
            LoanHeader.TESTFIELD("Reason for Closure");
        IF LoanHeader."Reason for Closure" <> '' THEN
            LoanHeader.TESTFIELD("Closed Date"); //credit facilty closing date

        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier CF");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Prev Data Prov ID No.", KSKLSetup."Prev Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");
        IFFVerification1.VALIDATE(IFFVerification1."Prev Data Prov Branch ID", KSKLSetup."Previous Branch Id");
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
        IFFVerification1.VALIDATE(IFFVerification1."Prev Loan No", '');
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Type", LoanHeader."Credit Facility Type");
        IFFVerification1.VALIDATE(IFFVerification1."Purpose of Credit Facility", LoanHeader."Purpose of Credit Facility");
        IFFVerification1.VALIDATE(IFFVerification1."Ownership Type", LoanHeader."Ownership Type");
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facilty Open Date", dateConversion(LoanHeader."Disbursement Date")); //create new filed on loan
        IFFVerification1.VALIDATE(IFFVerification1."Customer Credit Limit", ROUND(Customer."Customer Credit Limit", 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Sanction Amt", ABS(LoanHeader."Loan Amount"));
        IF LoanHeader."Credit Facility Sanction Curr" <> '' THEN
            IFFVerification1.VALIDATE(IFFVerification1."Credit Facilty Sanction Curr", LoanHeader."Credit Facility Sanction Curr") //credit facility sancation curency
        ELSE
            IFFVerification1."Credit Facilty Sanction Curr" := LoanHeader."Currency Code";
        IF Customer."Customer Credit Limit" < LoanHeader."Loan Amount" THEN
            ERROR('Customer credit limit must be greater than Disbursed Amount for Loan %1.', LoanHeader."Loan No.");
        /*IF Customer."Customer Credit Limit" < LoanHeader."Credit Facility Sanction Amt" THEN //reffered as Loan amount
          ERROR('Customer credit limit must be greater than Disbursed Amount.');
          */
        IFFVerification1.VALIDATE(IFFVerification1."Disbursement Date", dateConversion(LoanHeader."Disbursement Date"));
        IFFVerification1.VALIDATE(IFFVerification1."Disbursement Amount", LoanHeader."Loan Amount");
        IFFVerification1.VALIDATE(IFFVerification1."Natural Credit Exp Date", dateConversion(LoanHeader."Date to Clear Loan"));
        IFFVerification1.VALIDATE(IFFVerification1."Repayment Frequency", LoanHeader."Repayment Frequency");
        IFFVerification1.VALIDATE(IFFVerification1."No. of Installments", LoanHeader."Due Installments");
        IFFVerification1.VALIDATE(IFFVerification1."Amount of Installment", ROUND(LoanHeader."EMI Amount", 1, '=')); //EMI Amount
        IFFVerification1.VALIDATE(IFFVerification1."Total Outstanding Balance", ROUND(LoanHeader."Total Due", 1, '=')); //13 condition remaining
        IFFVerification1.VALIDATE(IFFVerification1."Highest Credit Usage", 0);
        IFFVerification1.VALIDATE(IFFVerification1."Currency Code", LoanHeader."Currency Code");
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
        //IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue",ROUND(LoanHeader."Due Principal"+LoanHeader."Interest Due",1,'=')); //verify again


        //for no intstallment overdue
        CLEAR(noInstallOverdue);
        CLEAR(Amt30);
        CLEAR(Amt60);
        CLEAR(Amt90);
        CLEAR(Amt120);
        CLEAR(Amt150);
        CLEAR(Amt180);
        CLEAR(Amt180more);
        LoanLine1.RESET;
        LoanLine1.SETRANGE("Loan No.", LoanHeader."Loan No.");
        LoanLine1.SETRANGE("Line Cleared", FALSE);
        LoanLine1.SETFILTER("EMI Mature Date", '<%1', TODAY);
        noInstallOverdue := LoanLine1.COUNT;
        IF LoanLine1.FINDSET THEN
            REPEAT
                LoanLine1.CALCFIELDS("Interest Paid", "Principal Paid", "Penalty Paid");
                /*
                    IF (LoanLine1."Delay by No. of Days" > 1 ) AND (LoanLine1."Delay by No. of Days" < 30 ) THEN
                  Amt30 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                  IF (LoanLine1."Delay by No. of Days" > 30  ) AND (LoanLine1."Delay by No. of Days" < 60 ) THEN
                    Amt60 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                  IF (LoanLine1."Delay by No. of Days" > 60 ) AND (LoanLine1."Delay by No. of Days" < 90 ) THEN
                    Amt90 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                  IF (LoanLine1."Delay by No. of Days" > 90 ) AND (LoanLine1."Delay by No. of Days" < 120 ) THEN
                    Amt120 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                  IF (LoanLine1."Delay by No. of Days" > 120 ) AND (LoanLine1."Delay by No. of Days" < 150 ) THEN
                    Amt150 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                  IF (LoanLine1."Delay by No. of Days" > 150 ) AND (LoanLine1."Delay by No. of Days" < 180 ) THEN
                    Amt180 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                  IF (LoanLine1."Delay by No. of Days" > 180 ) AND (LoanLine1."Delay by No. of Days" < 5000 ) THEN
                    Amt180more += LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                    *///old

                amtDone := FALSE;

                IF NOT amtDone AND (Amt30 = 0) THEN BEGIN
                    LoanLine1.CALCFIELDS("Interest Paid", "Principal Paid", "Penalty Paid");
                    IF (LoanLine1."Delay by No. of Days" > 1) AND (LoanLine1."Delay by No. of Days" < 30) THEN BEGIN
                        Amt30 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;
                    END;
                END;

                IF NOT (amtDone) AND (Amt60 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 30) > 30) AND ((LoanLine1."Delay by No. of Days" + 30) < 60)) THEN BEGIN
                        Amt60 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;
                    END;
                END;

                IF NOT amtDone AND (Amt90 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 60) > 60) AND ((LoanLine1."Delay by No. of Days" + 60) < 90)) THEN BEGIN
                        Amt90 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND (Amt120 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 90) > 90) AND ((LoanLine1."Delay by No. of Days" + 90) < 120)) THEN BEGIN
                        Amt120 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND (Amt150 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 120) > 120) AND ((LoanLine1."Delay by No. of Days" + 120) < 150)) THEN BEGIN
                        Amt150 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";

                    END;
                END;

                IF NOT amtDone AND (Amt180 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 150) > 150) AND ((LoanLine1."Delay by No. of Days" + 150) < 180)) THEN BEGIN
                        Amt180 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND (Amt180more = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 180) > 180) AND ((LoanLine1."Delay by No. of Days" + 180) < 5000)) THEN BEGIN
                        Amt180more += LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

            UNTIL LoanLine1.NEXT = 0;


        //26

        IFFVerification1."Amount OverDue" := IFFVerification1."Amount OverDue 1-30 Days" + IFFVerification1."Amount OverDue 31-60 Days" + IFFVerification1."Amount OverDue 61-90 Days" +
         IFFVerification1."Amount OverDue 91-120 Days" + IFFVerification1."Amount OverDue 121-150 Days" + IFFVerification1."Amount OverDue 151-180 Days" + IFFVerification1."Amount  Overdue 181 or More";
        IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Indicator", LoanHeader."Payment Dealy History Flag");//paile talla thiyo..mathi sareko
        LoanLine.RESET;
        LoanLine.SETRANGE(LoanLine."Loan No.", LoanHeader."Loan No."); //un
        //LoanLine.SETRANGE("Loan No.",'LO-000073');
        LoanLine.SETRANGE(LoanLine."Line Cleared", TRUE);

        IF LoanLine.FINDLAST THEN
            /*LoanLine.CALCFIELDS("Last Receipt No.");
            PaymentLine.RESET;
            PaymentLine.SETRANGE("G/L Receipt No.",LoanLine."Last Receipt No.");
            IF PaymentLine.FINDFIRST THEN
              IFFVerification1.VALIDATE(IFFVerification1."Last Repay Amount",ROUND(PaymentLine."Principal Paid"+PaymentLine."Interest Paid"+PaymentLine."Penalty Paid",1,'='));
              IFFVerification1.VALIDATE(IFFVerification1."Date of Last Repay",dateConversion(PaymentLine."Payment Date"));
              */
            //IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Indicator",LoanHeader."Payment Dealy History Flag");
            IF LoanLine."Delay by No. of Days" = 0 THEN BEGIN
                //Agni Inc UPG
                LoanLine1.RESET;
                LoanLine1.SETRANGE("Loan No.", LoanHeader."Loan No.");
                LoanLine1.SETRANGE("Line Cleared", TRUE);
                LoanLine1.SETFILTER("Last Payment Date", '<>%1', 0D);
                IF LoanLine1.FINDLAST THEN
                    LoanLine."Delay by No. of Days" := LoanLine1."Last Payment Date" - LoanLine."EMI Mature Date";
            END;

        //LoanLine."Delay by No. of Days" := LoanLine."Last Payment Date" - LoanLine."EMI Mature Date";
        //Agni Inc UPG
        IF LoanLine."Delay by No. of Days" <> 0 THEN BEGIN
            LLForPrecdDate.RESET;
            LLForPrecdDate.SETRANGE("Loan No.", LoanHeader."Loan No.");
            //Agni INC UPG
            //ronij oct 8 24
            IF KSKLSetup."Closed Loan" THEN BEGIN
                LLForPrecdDate.SETFILTER("EMI Mature Date", '<=%1', LoanHeader."Closed Date");
                IF LLForPrecdDate.FINDLAST THEN
                    IFFVerification1.VALIDATE("Immediate Preceeding Date", dateConversion(LLForPrecdDate."EMI Mature Date"));
            END ELSE BEGIN
                LLForPrecdDate.SETFILTER("EMI Mature Date", '<=%1', TODAY);
                IF LLForPrecdDate.FINDLAST THEN
                    IFFVerification1.VALIDATE("Immediate Preceeding Date", dateConversion(LLForPrecdDate."EMI Mature Date"));
            END;
            //Agni INC UPG
        END;


        IF IFFVerification1."Amount OverDue" <> 0 THEN BEGIN
            DPDDay := 0;
            LoanLineDPD.RESET;
            LoanLineDPD.SETRANGE("Loan No.", LoanHeader."Loan No.");
            LoanLineDPD.SETFILTER("EMI Mature Date", '<=%1', TODAY);
            LoanLineDPD.SETRANGE("Line Cleared", FALSE);
            IF LoanLineDPD.FINDFIRST THEN
                DPDDay := TODAY - LoanLineDPD."EMI Mature Date"
            ELSE
                DPDDay := 0;

            IF DPDDay > 999 THEN
                IFFVerification1.VALIDATE("Number of days over due", 999)
            ELSE
                IFFVerification1.VALIDATE("Number of days over due", DPDDay);
        END ELSE
            IFFVerification1.VALIDATE("Number of days over due", 0);
        /*
        IF DPDDay > 0 THEN
              IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days",0)
        ELSE
        */
        //Agni INC UPG
        // ronij 23 oct for closed loan
        IF NOT KSKLSetup."Closed Loan" THEN BEGIN
            PDDLoanLine.RESET;
            PDDLoanLine.SETRANGE("Loan No.", LoanHeader."Loan No.");
            PDDLoanLine.SETFILTER("EMI Mature Date", '<=%1', TODAY);
            // PDDLoanLine.SETRANGE("Line Cleared",TRUE);
            // PDDLoanLine.SETFILTER("Last Payment Date",'<>%1',0D);
            IF PDDLoanLine.FINDLAST THEN BEGIN
                //3/27/23
                IF PDDLoanLine."Line Cleared" THEN BEGIN
                    PDDLoanLine.CALCFIELDS("Last Receipt No.");
                    PaymentLine.RESET;
                    PaymentLine.SETRANGE("G/L Receipt No.", PDDLoanLine."Last Receipt No.");
                    IF PaymentLine.FINDFIRST THEN
                        IFFVerification1.VALIDATE(IFFVerification1."Last Repay Amount", ROUND(PaymentLine."Principal Paid" + PaymentLine."Interest Paid" + PaymentLine."Penalty Paid", 1, '='));
                    IFFVerification1.VALIDATE(IFFVerification1."Date of Last Repay", dateConversion(PaymentLine."Payment Date"));
                END;
                //Agni INC UPG
            END;
        END;

        //3.27
        IF PaymentLine."Payment Date" <> 0D THEN BEGIN
            PDDLoanLine1.RESET;
            PDDLoanLine1.SETRANGE("Loan No.", LoanHeader."Loan No.");
            PDDLoanLine1.SETFILTER("EMI Mature Date", '<=%1', TODAY);

            IF PDDLoanLine1.FINDLAST THEN BEGIN
                IF (PDDLoanLine1."EMI Mature Date" <> 0D) AND (PDDLoanLine1."Last Payment Date" <> 0D) THEN
                    IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days", PDDLoanLine1."Last Payment Date" - PDDLoanLine1."EMI Mature Date");
            END;
        END;
        //IF (LoanLineDPD."EMI Mature Date" <> 0D) AND (LoanLineDPD."Last Payment Date" <> 0D) THEN
        //    IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days",LoanLineDPD."Last Payment Date" - LoanLineDPD."EMI Mature Date");
        //IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days",LoanLineDPD."EMI Mature Date" - LoanLineDPD."Last Payment Date");
        //IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days",LLForPrecdDate."EMI Mature Date" - LoanHeader."Last Payment Date");

        //  IFFVerification1.VALIDATE(IFFVerification1.No of days overdue); //not foound
        IFFVerification1.VALIDATE(IFFVerification1."No of Installments Overdue", noInstallOverdue); //days overdue //overdue not found if any add field
                                                                                                    //IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue",ROUND(LoanHeader."Total Due as of Today",1,'=')); //verify again
                                                                                                    // IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue",ROUND(LoanHeader."Due Principal"+LoanHeader."Interest Due",1,'=')); //13 verify again
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 1-30 Days", ROUND(Amt30, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 31-60 Days", ROUND(Amt60, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 61-90 Days", ROUND(Amt90, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 91-120 Days", ROUND(Amt120, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 121-150 Days", ROUND(Amt150, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 151-180 Days", ROUND(Amt180, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount  Overdue 181 or More", ROUND(Amt180more, 1, '=')); //26

        IFFVerification1.VALIDATE(IFFVerification1."Assets Classification", FORMAT(LoanHeader."Asset Claasification"));
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Status", LoanHeader."Credit Facility Status");
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Closing Date", dateConversion(LoanHeader."Closed Date")); //revisit
        IFFVerification1.VALIDATE(IFFVerification1."Reason for Closure", LoanHeader."Reason for Closure");
        IFFVerification1.VALIDATE(IFFVerification1."Security Coverage Flag", FORMAT(LoanHeader."Security Coverage Flag"));
        IFFVerification1.VALIDATE(IFFVerification1."Legal Action Taken", Customer."Legal Action Taken");
        //IFFVerification1.VALIDATE(IFFVerification1."Info Update On",dateConversion(LoanHeader."Last Date Modified"));
        //Agni INC UPG
        IF KSKLSetup."Closed Loan" THEN BEGIN // ronij
            IFFVerification1.VALIDATE(IFFVerification1."Info Update On", dateConversion(LoanHeader."Closed Date"));
        END ELSE BEGIN
            IFFVerification1.VALIDATE(IFFVerification1."Info Update On", dateConversion(TODAY));
            IF LLForPrecdDate."EMI Mature Date" <> 0D THEN
                IFFVerification1.VALIDATE(IFFVerification1."Info Update On", dateConversion(LLForPrecdDate."EMI Mature Date"));
        END;
        //Agni INC UPG
        IFFVerification1.VALIDATE(IFFVerification1."Time of Update", timeConversion(TIME));
        IF IFFVerification1."Amount OverDue" <> 0 THEN
            IFFVerification1."Payment Delay Days" := 0;

    end;

    local procedure insertAndUpdateCHCommercial(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier CH");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");// not  found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
        IFFVerification1.VALIDATE(IFFVerification1."Date Reported", dateConversion(TODAY));//not found
        IFFVerification1.VALIDATE(IFFVerification1."Installment Due Date", dateConversion(LoanLine."EMI Mature Date"));//verify again
        IFFVerification1.VALIDATE(IFFVerification1."Payment Due Settlment Date", dateConversion(LoanHeader."Payment Receipt Date"));//not found
        IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days", LoanLine."Delay by No. of Days");
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
    end;

    local procedure insertAndUpdateCSCommercial(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier CS");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");//check once,credit facility number or not
        IFFVerification1.VALIDATE(IFFVerification1."Customer No.", LoanHeader."Customer No.");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Prev Customer No.", '');// not found
        IFFVerification1.VALIDATE(IFFVerification1."Subject Name", Customer."Subject Name");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Subject Prev Name", Customer."Subject Prev Name");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Legal Status", Customer."Legal Status");
        IFFVerification1.VALIDATE(IFFVerification1."Date of Comp Redg", dateConversion(Customer."Date of Company Redg"));
        IFFVerification1.VALIDATE(IFFVerification1.PAN, Customer.PAN);
        IFFVerification1.VALIDATE(IFFVerification1."Previous PAN", Customer."Previous PAN");
        IFFVerification1.VALIDATE(IFFVerification1."PAN Issue Date", Customer."PAN Issue Date");
        IFFVerification1.VALIDATE(IFFVerification1."PAN Issue District", Customer."PAN Issue District");
        IFFVerification1.VALIDATE(IFFVerification1."Comp Redg No.", Customer."Company  Redg No."); //not found
        IFFVerification1.VALIDATE(IFFVerification1."Comp Redg Issued Authority", Customer."Comp Regd No Issud Authority");
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Type", Customer."Address Type");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Line 1", Customer."Address 1 Line 1"); //not found
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Line 2", Customer."Address 1 Line 2"); //not found
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Line 3", Customer."Address 1 Line 3"); //not found
        IFFVerification1.VALIDATE(IFFVerification1."Address1 District", Customer."Address District"); //verify again
        IFFVerification1.VALIDATE(IFFVerification1."Address1 PO Box", Customer."PO Box");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Country", Customer."Address 1 Country"); //field not found
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Type", Customer."Address 2 Type");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Line 1", Customer."Address 2 Line 1");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Line 2", Customer."Address 2 Line 2");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Line 3", Customer."Address 2 Line 3");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 District", Customer."Address 2 District");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Power BOX", Customer."Address 2 Power Box");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Country", Customer."Address 2 Country");
        IFFVerification1.VALIDATE(IFFVerification1."Telephone 1", Customer."Telephone No.");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Telephone Number 2", Customer."Telephone Number 2");// field not found
        IFFVerification1.VALIDATE(IFFVerification1."Mobile Number", COPYSTR(Customer."Mobile No.", 1, 10));
        IFFVerification1.VALIDATE(IFFVerification1."Business Activity Code", Customer."Business Activity Code");
        IFFVerification1.VALIDATE(IFFVerification1."Fax 1", Customer."Fax 1");//two fax1 exist
        IFFVerification1.VALIDATE(IFFVerification1.Fax2, Customer."Fax 2");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Email Address", Customer."E-Mail");// verify once since e-mail &e-mail2 exist
        IFFVerification1.VALIDATE(IFFVerification1.Group, Customer.Group);
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
    end;

    local procedure insertAndUpdateRSCommercial(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        IFFVerification2: Record "33019803";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier RS");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        //iffverf2 shown
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");//cred.fac.Status & cred.Fac.Numb same or not
        IFFVerification1.VALIDATE(IFFVerification1."Customer No.", Customer."No.");//verify once
        //Related Entity new table Custpmer Related Entity
        CustomerRelatedEntity.TESTFIELD("RS Nature of Relationship");
        CustomerRelatedEntity.TESTFIELD("Related Entities Type");
        IFFVerification1.VALIDATE(IFFVerification1."Related Entity Type", CustomerRelatedEntity."Related Entities Type");
        IFFVerification1.VALIDATE(IFFVerification1."Nature of Relationship", CustomerRelatedEntity."RS Nature of Relationship");
        IFFVerification1.VALIDATE(IFFVerification1."Related Entities Name", CustomerRelatedEntity."Related Entities Name");
        IF CustomerRelatedEntity."Related Entities Type" = '002' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RS Legal Status");
            IFFVerification1.VALIDATE(IFFVerification1."Legal Status", CustomerRelatedEntity."RS Legal Status");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."Date of Birth Comp Redg", dateConversion(CustomerRelatedEntity."Related Entity DOB"));
        IFFVerification1.VALIDATE(IFFVerification1."RE Comp Redg No.", CustomerRelatedEntity."RE Company Registration No.");//new
        IF CustomerRelatedEntity."RE Company Registration No." <> '' THEN
            CustomerRelatedEntity.TESTFIELD("RE Comp Reg No Issued Auth");
        IFFVerification1.VALIDATE(IFFVerification1."RE Comp Reg No. Issued Auth", CustomerRelatedEntity."RE Comp Reg No Issued Auth"); //new
        IFFVerification1.VALIDATE(IFFVerification1."RE Citizenship No.", CustomerRelatedEntity."RE Citizenship No"); //new
        IF CustomerRelatedEntity."RE Citizenship No" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RE Citizenship No Issued Date");
            CustomerRelatedEntity.TESTFIELD("RE Citizenship No Issued Distr");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."RE Prev Citizenship No.", CustomerRelatedEntity."RE Prev Citizenship No");//new
        IFFVerification1.VALIDATE(IFFVerification1."RE Citizenship No. Issued Date", CustomerRelatedEntity."RE Citizenship No Issued Date");//new //nepali
        IFFVerification1.VALIDATE(IFFVerification1."RE Citizen No. Issued District", CustomerRelatedEntity."RE Citizenship No Issued Distr");// new
        IFFVerification1.VALIDATE(IFFVerification1."RE PAN", CustomerRelatedEntity."RE PAN");
        IFFVerification1.VALIDATE(IFFVerification1."RE Previous PAN", CustomerRelatedEntity."RE Prev PAN");
        IF CustomerRelatedEntity."RE PAN" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RE PAN No Issued Date");
            CustomerRelatedEntity.TESTFIELD("RE PAN No Issued District");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."RE PAN No. Issue Date", CustomerRelatedEntity."RE PAN No Issued Date");
        IFFVerification1.VALIDATE(IFFVerification1."RE PAN issued District", CustomerRelatedEntity."RE PAN No Issued District");//new
        IFFVerification1.VALIDATE(IFFVerification1."RE Passport", CustomerRelatedEntity."RE Passport");//new
        IFFVerification1.VALIDATE(IFFVerification1."RE Previous Passport", CustomerRelatedEntity."RE Prev passport");//new
        IF CustomerRelatedEntity."RE Passport" <> '' THEN
            CustomerRelatedEntity.TESTFIELD("RE Passport Exp Date");
        IFFVerification1.VALIDATE(IFFVerification1."Passport No. Expiry Date", dateConversion(CustomerRelatedEntity."RE Passport Exp Date"));
        IFFVerification1.VALIDATE(IFFVerification1."RE Voter ID", CustomerRelatedEntity."RE Voter ID");//new
        IF CustomerRelatedEntity."RE Voter ID" <> '' THEN
            CustomerRelatedEntity.TESTFIELD("RE Voter ID No Issued Date");

        IFFVerification1.VALIDATE(IFFVerification1."RE Previous Voter ID", CustomerRelatedEntity."RE Prev Voter ID");
        IFFVerification1.VALIDATE(IFFVerification1."RE Voter ID No. Issued Date", CustomerRelatedEntity."RE Voter ID No Issued Date");
        IFFVerification1.VALIDATE(IFFVerification1."IN Embassy Reg No.", CustomerRelatedEntity."RS Indian Embassy Reg No.");// not found-- two reg date was found
        IFFVerification1.VALIDATE(IFFVerification1."IN Embasssy Reg No. Issue Date", dateConversion(CustomerRelatedEntity."RS Indain Embassy Date"));// verify once
        IF CustomerRelatedEntity."Related Entities Type" = '001' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RS Gurantee Type");
            CustomerRelatedEntity.TESTFIELD("Percentage of Control");
            CustomerRelatedEntity.TESTFIELD("RS Father Name");
            IFFVerification1.VALIDATE(IFFVerification1."Percentage of Control", CustomerRelatedEntity."Percentage of Control");
        END ELSE BEGIN
            IFFVerification1.VALIDATE(IFFVerification1."Percentage of Control", CustomerRelatedEntity."Percentage of Control");

            // IF CustomerRelatedEntity."Percentage of Control" <> 0 THEN
            // ERROR('Percentancge control should not have value. %1',LoanHeader."Loan No."); //7.24.2023
        END;

        IFFVerification1.VALIDATE(IFFVerification1."Guarantee Type", CustomerRelatedEntity."RS Gurantee Type");
        IFFVerification1.VALIDATE(IFFVerification1."Date of Leaving", dateConversion(CustomerRelatedEntity."RS Date of Leaving"));
        IFFVerification1.VALIDATE(IFFVerification1."Father Name", CustomerRelatedEntity."RS Father Name");
        IFFVerification1.VALIDATE(IFFVerification1."Grand Father Name", Customer."Grand Father Name");// not found
        IFFVerification1.VALIDATE(IFFVerification1."Spouse1 Name", Customer."Spouse 1 Name");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Spouse2 Name", Customer."Spouse 2 Name");// not found
        IFFVerification1.VALIDATE(IFFVerification1."Mother Name", Customer."Mother's Name");// not found
        IFFVerification1.VALIDATE(IFFVerification1."Related Indiv Nationality", CustomerRelatedEntity."Related Indiv Nationality");// from new table
        IF CustomerRelatedEntity."Related Entities Type" = '001' THEN
            IFFVerification1.VALIDATE(IFFVerification1."RE Gender", CustomerRelatedEntity."RE Gender");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Type", CustomerRelatedEntity."RE Entities Address Type");//VERIFY ONCE IN IFF
        IFFVerification1.VALIDATE(IFFVerification1."RE Address 1 Line 1", CustomerRelatedEntity."RE Entities Address Line 1"); // both not found
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Line 2", CustomerRelatedEntity."RE Entities Address Line 2"); //new
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Line 3", CustomerRelatedEntity."RE Entities Address Line 3");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address District", CustomerRelatedEntity."RE Entities Address District");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address P.O Box No", CustomerRelatedEntity."RE Entities Addr PO Box No");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Country", CustomerRelatedEntity."RE Entities Address Country");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Telephone No.1", CustomerRelatedEntity."RE Entities Telephone No 1");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Telephone No.2", CustomerRelatedEntity."RE Entities Telephone No 2");
        IFFVerification1.VALIDATE(IFFVerification1."Related Indv. Mobile No.", CustomerRelatedEntity."Related Indiv Mobile No");
        IFFVerification1.VALIDATE(IFFVerification1."Fax 1", Customer."Fax 1");// verify again
        IFFVerification1.VALIDATE(IFFVerification1.Fax2, Customer."Fax 2");// not found
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Email Address", CustomerRelatedEntity."RE Entities Email Address");
        IFFVerification1.VALIDATE(IFFVerification1.Group, Customer.Group);
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
    end;

    local procedure insertAndUpdateBRCommercial(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
        IFFVerification1.VALIDATE(IFFVerification1."Segment Identifier", KSKLSetup."Segment Identifier BR");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");//verify once Credit facilty number is equalto status or not
        IFFVerification1.VALIDATE(IFFVerification1."Customer No.", Customer."No.");//verify once
        IFFVerification1.VALIDATE(IFFVerification1."BR Entity Type", CustomerRelatedEntity."BR RE Type");//new one
        IFFVerification1.VALIDATE("BR RE Name", CustomerRelatedEntity."BR RE Name");
        CustomerRelatedEntity.TESTFIELD("BR Nature of Relationship");
        IFFVerification1.VALIDATE(IFFVerification1."Nature of Relationship", CustomerRelatedEntity."BR Nature of Relationship");// new from table
        IFFVerification1.VALIDATE(IFFVerification1."Legal Status", CustomerRelatedEntity."BR Legal Status");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE DOB/Date of Reg", dateConversion(CustomerRelatedEntity."BR RE DOB/Date of Regd"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Comp Reg No.", CustomerRelatedEntity."BR RE Comp Regd No");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Comp Reg No. Issue Auth", CustomerRelatedEntity."BR RE Comp Regd No Issud Auth");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Citizenship No.", CustomerRelatedEntity."BR RE Citizenship No");
        IFFVerification1.VALIDATE("Related Entity Type", CustomerRelatedEntity."Related Entities Type"); //to skip if has 001 value
        IF CustomerRelatedEntity."BR RE Citizenship No" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("BR RE Citizenship No Issd Date");
            CustomerRelatedEntity.TESTFIELD("BR RE Citizenship No Issd Dist");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Prev. Citizenship No.", CustomerRelatedEntity."BR RE Prev Citizenship No");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Citizen No. Issued Date", checkNepaliDate(CustomerRelatedEntity."BR RE Citizenship No Issd Date"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Citizen No. Issue Dist", CustomerRelatedEntity."BR RE Citizenship No Issd Dist");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE PAN", CustomerRelatedEntity."BR RE PAN");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Prev. PAN", CustomerRelatedEntity."BR RE Prev PAN");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE PAN No. Issued Date", CustomerRelatedEntity."BR RE PAN No Issud Date");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE PAN Issued District", CustomerRelatedEntity."BR RE PAN Issued District");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Passport", CustomerRelatedEntity."BR RE Passport");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Previous Passport", CustomerRelatedEntity."BR RE Prev Passport");
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
        //SP
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Passport No. Exp Date", dateConversion(CustomerRelatedEntity."BR RE Passport No Expiry Date"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Voter ID", CustomerRelatedEntity."BR RE Voter ID");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Prev. Voter ID", CustomerRelatedEntity."BR RE Prev Voter ID");
        //IFFVerification1.VALIDATE(IFFVerification1."BR RE Voter ID No. Issued Date",EngNepDate.getNepaliDate()); issued dates
        IFFVerification1.VALIDATE(IFFVerification1."BR Re In Emb Regd No", CustomerRelatedEntity."BR RE Ind Emb Regd No");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE IN Emb Reg No. Issue Dat", dateConversion(CustomerRelatedEntity."BR RE Ind Emb Reg No Issd Date"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Gender", CustomerRelatedEntity."BR RE Gender");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Percentage of control", CustomerRelatedEntity."BR RE Percenage of Control");// verify once
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Date of Leaving", dateConversion(CustomerRelatedEntity."BR RE Date of Leaving"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Father Name", CustomerRelatedEntity."BR RE Father Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Grand Father Name", CustomerRelatedEntity."BR RE Grand Father Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Spouse1 Name", CustomerRelatedEntity."BR RE Spouse 1 Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Spouse2 Name", CustomerRelatedEntity."BR RE Spouse 2 Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Mother Name", CustomerRelatedEntity."BR RE Mother Name");
        IF CustomerRelatedEntity."BR RE Type" = '001' THEN BEGIN
            IFFVerification1.VALIDATE(IFFVerification1."BR Nationality", CustomerRelatedEntity."BR Nationality");
            IF CustomerRelatedEntity."BR Legal Status" <> '' THEN
                ERROR('You cant enter legal status while BR related entity is 001 for Loan %1', LoanHeader."Loan No.");
        END ELSE BEGIN
            IFFVerification1.VALIDATE(IFFVerification1."BR Nationality", '');
            CustomerRelatedEntity.TESTFIELD("BR Legal Status");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Type", CustomerRelatedEntity."BR RE Address Type");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Line 1", CustomerRelatedEntity."BR RE Address Line 1");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Line 2", CustomerRelatedEntity."BR RE Address Line 2");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Line 3", CustomerRelatedEntity."BR RE Address Line 3");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE District", CustomerRelatedEntity."BR RE District");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE P.O. Box", CustomerRelatedEntity."BR RE PO BOX");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Country", CustomerRelatedEntity."BR RE Country");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Telephone No. 1", CustomerRelatedEntity."BR RE Telephone No 1");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Telephone No. 2", CustomerRelatedEntity."BR RE Telephone No 2");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Mobile No.", CustomerRelatedEntity."BR RE Mobile No");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Fax 1", CustomerRelatedEntity."BR RE Fax1");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Fax2", CustomerRelatedEntity."BR RE Fax2");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Email", CustomerRelatedEntity."BR RE Email");
        IFFVerification1.VALIDATE(IFFVerification1.Group, Customer.Group);
    end;

    local procedure insertAndUpdateSSCommercial(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;

        IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier SS");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");// not found
        IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");
        IFFVerification2.VALIDATE(IFFVerification2."Customer Number", Customer."No.");
        IFFVerification2.VALIDATE(IFFVerification2."Type of Security", CustomerRelatedEntity."SS Type of Security");
        IFFVerification2.VALIDATE(IFFVerification2."Security Ownership Type", CustomerRelatedEntity."SS Security Ownership Type");
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Type", CustomerRelatedEntity."Security Valuator Type");// not found
        IFFVerification2.VALIDATE(IFFVerification2."Description of Security", CustomerRelatedEntity."Description Of Security");//
        IFFVerification2.VALIDATE(IFFVerification2."Nature of Charge", CustomerRelatedEntity."Nature of Charge");//not
        IFFVerification2.VALIDATE(IFFVerification2."Security Coverage Percentage", FORMAT(CustomerRelatedEntity."Security Coverage Percentage"));//not
        IFFVerification2.VALIDATE(IFFVerification2."Latest Value of Security", CustomerRelatedEntity."Latest Value of Security");//not

        IFFVerification2.VALIDATE(IFFVerification2."Date of Latest Valuation", dateConversion(CustomerRelatedEntity."Date of Latest Valuation"));// not
        IFFVerification2.VALIDATE("File Type", IFFVerification1."File Type"::Commercial);
    end;

    local procedure insertAndUpdateVSCommercial(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062"; CustomerRelatedEntity: Record "33019804")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
    begin
        KSKLSetup.GET;
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
        IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier VS");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");
        IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");
        IFFVerification2.VALIDATE(IFFVerification2."Customer Number", CustomerRelatedEntity."Valuator No.");
        CustomerRelatedEntity.TESTFIELD("Valuator No."); //13
        IFFVerification2.VALIDATE(IFFVerification2."Previous Customer No", '');//not found
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Entity Type", CustomerRelatedEntity."Valuator Entity Type");
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Entity's Name", CustomerRelatedEntity."Valuator Entities Name");
        IFFVerification2.VALIDATE(IFFVerification2."Legal Status", CustomerRelatedEntity."VS Legal Status");
        IFFVerification2.VALIDATE(IFFVerification2."VE DOB/Comp Reg Date", dateConversion(CustomerRelatedEntity."VE DOB/Comp Regd Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VE Comp Reg No.", CustomerRelatedEntity."VE Comp Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VE Comp Reg No. Issue Auth", CustomerRelatedEntity."VE Comp Regd No Issud Auth");
        IF CustomerRelatedEntity."VE Citizenship No" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("VE Citizenship No Issud Date");
            CustomerRelatedEntity.TESTFIELD("VE Citizenship No Issud Distr");
        END;
        IFFVerification2.VALIDATE(IFFVerification2."VE Citizenship No", CustomerRelatedEntity."VE Citizenship No");
        IFFVerification2.VALIDATE(IFFVerification2."VE Previous Citizenship No.", CustomerRelatedEntity."VE Prev Citizenship No");
        IFFVerification2.VALIDATE(IFFVerification2."VE Citizenship No. Issued Date", CustomerRelatedEntity."VE Citizenship No Issud Date");
        IFFVerification2.VALIDATE(IFFVerification2."VE Citizenship No. Issued Dist", CustomerRelatedEntity."VE Citizenship No Issud Distr");
        IFFVerification2.VALIDATE(IFFVerification2."VE PAN", CustomerRelatedEntity."VE PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VE Prev PAN", CustomerRelatedEntity."VE Prev PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VE PAN No. Issued Date", CustomerRelatedEntity."VE PAN No Issued Date");
        IFFVerification2.VALIDATE(IFFVerification2."VE PAN No. Isueed District", CustomerRelatedEntity."VE PAN No Issued Dist");
        IFFVerification2.VALIDATE(IFFVerification2."VE Passport", CustomerRelatedEntity."VE Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VE Previous Passport", CustomerRelatedEntity."VE Prev Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VE Passport No. Exp Date", dateConversion(CustomerRelatedEntity."VE Passport No Expiry Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VE Voter ID", CustomerRelatedEntity."VE Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VE Prev Voter ID", CustomerRelatedEntity."VE prev Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VE Voter ID No. Issued Date", CustomerRelatedEntity."VE voter ID No Issued Date");
        IFFVerification2.VALIDATE(IFFVerification2."VE IN EMB Reg No.", CustomerRelatedEntity."VE Ind Emb Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VE IN EMB Reg No. Issue Date", dateConversion(CustomerRelatedEntity."VE Ind Emb Regd No Issud Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VE Gender", CustomerRelatedEntity."VE Gender");
        IFFVerification2.VALIDATE(IFFVerification2."VE Father's Name", CustomerRelatedEntity."VE Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Grand Father's Name", CustomerRelatedEntity."VE Grand Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Spouse1 Name", CustomerRelatedEntity."VE Spouse 1 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Spouse2 Name", CustomerRelatedEntity."VE Spouse 2 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Mother's Name", CustomerRelatedEntity."VE Mother Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Type", CustomerRelatedEntity."VE Address Type");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Line 1", CustomerRelatedEntity."VE Address Line1");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Line 2", CustomerRelatedEntity."VE Address Line2");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Line 3", CustomerRelatedEntity."VE Address Lne3");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address District", CustomerRelatedEntity."VE Address District");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address P.O. Box", CustomerRelatedEntity."VE Address PO Box");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Country", CustomerRelatedEntity."VE Address Country");
        IFFVerification2.VALIDATE(IFFVerification2."VE Telephone No. 1", CustomerRelatedEntity."VE Telephone Number1");
        IFFVerification2.VALIDATE(IFFVerification2."VE Telephone No. 2", CustomerRelatedEntity."VE Telephone Number2");
        IFFVerification2.VALIDATE(IFFVerification2."VE Mobile No.", COPYSTR(CustomerRelatedEntity."VE Mobile Number", 1, 10));
        IFFVerification2.VALIDATE(IFFVerification2."VE Fax 1", CustomerRelatedEntity."VE Fax1");
        IFFVerification2.VALIDATE(IFFVerification2."VE Fax 2", CustomerRelatedEntity."VE Fax2");
        IFFVerification2.VALIDATE(IFFVerification2."VE Email", CustomerRelatedEntity."VE Email");
        IFFVerification2.VALIDATE("File Type", IFFVerification2."File Type"::Commercial);
        IFFVerification2.VALIDATE(IFFVerification2.Group, Customer.Group);//not found
    end;

    local procedure insertAndUpdateVRCommercial(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        Customer.TESTFIELD("Related Entity Number");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
        IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier VR");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");//not found
        IFFVerification2.VALIDATE(IFFVerification2."Customer Number", CustomerRelatedEntity."Valuator No.");
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Rltn Entity Type", CustomerRelatedEntity."Valuator Reltn Entity Type");//new
        IFFVerification2.VALIDATE(IFFVerification2."Nature of Relationship", CustomerRelatedEntity."VR Nature of Relationship");
        IFFVerification2.VALIDATE(IFFVerification2."VR Name", CustomerRelatedEntity."VR Name");//new
        IFFVerification2.VALIDATE(IFFVerification2."Legal Status", Customer."Legal Status");
        IFFVerification2.VALIDATE(IFFVerification2."VR DOB/Date of Reg", dateConversion(CustomerRelatedEntity."VR DOB/Date of Regd"));
        IFFVerification2.VALIDATE(IFFVerification2."VR BE Comp Reg No.", CustomerRelatedEntity."VR BE Comp Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VR BE Comp Reg No. Issued Auth", CustomerRelatedEntity."VR BE Comp Regd No Issud Auth");
        IFFVerification2.VALIDATE(IFFVerification2."VR Indv. Citizenship No.", CustomerRelatedEntity."Valuator Indiv Reltn CitizenNo");
        IF CustomerRelatedEntity."Valuator Indiv Reltn CitizenNo" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("VRE Citizenship No Issud Date");
            CustomerRelatedEntity.TESTFIELD("VRE Citizenship No Issud Dist");
        END;
        IFFVerification2.VALIDATE(IFFVerification2."VR Entity's Prev. Citizen No.", CustomerRelatedEntity."VRE Prev Citizenship No");
        IFFVerification2.VALIDATE(IFFVerification2."VR Entity CitizenNo IssueDate", CustomerRelatedEntity."VRE Citizenship No Issud Date");
        IFFVerification2.VALIDATE(IFFVerification2."VR Entity CitizenNo IssueDistr", CustomerRelatedEntity."VRE Citizenship No Issud Dist");
        IFFVerification2.VALIDATE(IFFVerification2."VRE PAN", CustomerRelatedEntity."VRE PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Prev PAN", CustomerRelatedEntity."VRE Prev PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VRE PAN No. Issued Date", dateConversion(CustomerRelatedEntity."VRE PAN No Issud Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VRE BE PAN issued District", CustomerRelatedEntity."VRE BE PAN issud District");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Passport", CustomerRelatedEntity."VRE Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Previous Passport", CustomerRelatedEntity."VRE Prev Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Passport No. Exp Date", dateConversion(CustomerRelatedEntity."VRE Passport No Exp Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VRE Voter ID", CustomerRelatedEntity."VRE Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Prev. Voter ID", CustomerRelatedEntity."VRE Prev Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Voter ID No. Issued Date", dateConversion(CustomerRelatedEntity."VRE Voter ID No Issud Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VRE IN EMB Reg No.", CustomerRelatedEntity."VRE Ind Emb Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VRE IN EMB Reg Issue Date", dateConversion(CustomerRelatedEntity."VRE Ind Emb Regd No Issd Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VR Gender", CustomerRelatedEntity."VR Gender");
        IFFVerification2.VALIDATE(IFFVerification2."VR Percentage of Control", CustomerRelatedEntity."VR Percentage of control");
        IFFVerification2.VALIDATE(IFFVerification2."VR Date of Leaving", dateConversion(CustomerRelatedEntity."VR Date of Leaving"));
        IFFVerification2.VALIDATE(IFFVerification2."VR Father's Name", CustomerRelatedEntity."VR Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Grand Father's Name", CustomerRelatedEntity."VR Grand Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Spouse1 Name", CustomerRelatedEntity."VR Spouse1 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Spouse2 Name", CustomerRelatedEntity."Vr Spouse2 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Mother's Name", CustomerRelatedEntity."VR Mother Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Type", CustomerRelatedEntity."VR Address Type");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Line 1", CustomerRelatedEntity."VR Address Line1");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Line 2", CustomerRelatedEntity."VR Address Line2");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Line 3", CustomerRelatedEntity."VR Address Line3");
        IFFVerification2.VALIDATE(IFFVerification2."VR District", CustomerRelatedEntity."VR District");
        IFFVerification2.VALIDATE(IFFVerification2."VR PO BOX", CustomerRelatedEntity."VR PO Box");
        IFFVerification2.VALIDATE(IFFVerification2."VR Country", CustomerRelatedEntity."VR Country");
        IFFVerification2.VALIDATE(IFFVerification2."VR Telephone No.1", CustomerRelatedEntity."VR Telephone No.1");
        IFFVerification2.VALIDATE(IFFVerification2."VR Telephone No.2", CustomerRelatedEntity."VR Telephone No.2");
        IFFVerification2.VALIDATE(IFFVerification2."VR Mobile No.", COPYSTR(CustomerRelatedEntity."VR Mobile Number", 1, 10));
        IFFVerification2.VALIDATE(IFFVerification2."VR Fax 1", CustomerRelatedEntity."VR Fax1");
        IFFVerification2.VALIDATE(IFFVerification2."VR Fax 2", CustomerRelatedEntity."VR Fax2");
        IFFVerification2.VALIDATE(IFFVerification2."VR Email", CustomerRelatedEntity."VR Email");
        IFFVerification2.VALIDATE(IFFVerification2.Group, Customer.Group);
        IFFVerification2.VALIDATE("File Type", IFFVerification2."File Type"::Commercial);
    end;

    local procedure insertAndUpdateTLCommercial(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IFFVerification2.VALIDATE(IFFVerification2."Segment Identifier", KSKLSetup."Segment Identifier TL");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");//not found
        IFFVerification2.VALIDATE("File Type", IFFVerification2."File Type"::Commercial);


        //
        //************ Consumer Form here *************//
        //
    end;

    local procedure insertAndUpdateHDConsumer(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier HD");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Reporting Date", dateConversion(TODAY));
        IFFVerification1.VALIDATE(IFFVerification1."Reporting Time", timeConversion(TIME));
        IFFVerification1.VALIDATE(IFFVerification1."Date of Prep File", dateConversion(TODAY));
        IFFVerification1.VALIDATE(IFFVerification1."Nature of Data", FORMAT(KSKLSetup."Nature of Data(Consumer)"));
        IFFVerification1.VALIDATE(IFFVerification1."IFF Version ID(Consumer)", FORMAT(KSKLSetup."IFF Version ID(Consumer)"));
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);

    end;

    local procedure insertAndUpdateCFConsumer(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
        LoanLine1: Record "33020063";
        noInstallOverdue: Integer;
        Amt30: Decimal;
        Amt60: Decimal;
        Amt90: Decimal;
        Amt120: Decimal;
        Amt150: Decimal;
        Amt180: Decimal;
        Amt180more: Decimal;
        LoanLineDPD: Record "33020063";
        DPDDay: Integer;
        LLForPrecdDate: Record "33020063";
        PaymentLine: Record "33020072";
        PDDLoanLine: Record "33020063";
        PDDLoanLine1: Record "33020063";
        amtDone: Boolean;
        LoanLineNew: Record "33020063";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IF LoanHeader."Loan Amount" > Customer."Customer Credit Limit" THEN
            ERROR('Customer Credit Facilty Sanction Amount not less than Customer Credit Limit.');
        IF (LoanHeader."Credit Facility Status" = '003') OR (LoanHeader."Credit Facility Status" = '004') THEN
            LoanHeader.TESTFIELD("Reason for Closure");
        IF LoanHeader."Reason for Closure" <> '' THEN
            LoanHeader.TESTFIELD("Closed Date");

        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier CF");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Prev Data Prov ID No.", KSKLSetup."Prev Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");
        IFFVerification1.VALIDATE(IFFVerification1."Prev Data Prov Branch ID", '');
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No."); //credit facility number
        IFFVerification1.VALIDATE(IFFVerification1."Prev Loan No", '');
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Type", LoanHeader."Credit Facility Type");
        IFFVerification1.VALIDATE(IFFVerification1."Purpose of Credit Facility", LoanHeader."Purpose of Credit Facility");
        IFFVerification1.VALIDATE(IFFVerification1."Ownership Type", LoanHeader."Ownership Type");
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facilty Open Date", dateConversion(LoanHeader."Disbursement Date")); //create new filed on loan
        IFFVerification1.VALIDATE(IFFVerification1."Customer Credit Limit", ROUND(Customer."Customer Credit Limit", 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Sanction Amt", ABS(LoanHeader."Loan Amount"));
        IF LoanHeader."Credit Facility Sanction Curr" <> '' THEN
            IFFVerification1.VALIDATE(IFFVerification1."Credit Facilty Sanction Curr", LoanHeader."Credit Facility Sanction Curr") //credit facility sancation curency
        ELSE
            IFFVerification1."Credit Facilty Sanction Curr" := LoanHeader."Currency Code"; //credit facility sancation curency
        IF Customer."Customer Credit Limit" < LoanHeader."Loan Amount" THEN
            ERROR('Customer credit limit must be greater than Disbursed Amount for Loan %1', LoanHeader."Loan No.");
        IFFVerification1.VALIDATE(IFFVerification1."Disbursement Date", dateConversion(LoanHeader."Disbursement Date"));
        IFFVerification1.VALIDATE(IFFVerification1."Disbursement Amount", LoanHeader."Loan Amount");
        IFFVerification1.VALIDATE(IFFVerification1."Natural Credit Exp Date", dateConversion(LoanHeader."Date to Clear Loan"));
        IFFVerification1.VALIDATE(IFFVerification1."Repayment Frequency", LoanHeader."Repayment Frequency");
        IFFVerification1.VALIDATE(IFFVerification1."No. of Installments", LoanHeader."Due Installments");
        IFFVerification1.VALIDATE(IFFVerification1."Amount of Installment", ROUND(LoanHeader."EMI Amount", 1, '=')); //EMI Amount
        IFFVerification1.VALIDATE(IFFVerification1."Total Outstanding Balance", ROUND(LoanHeader."Total Due", 1, '=')); //condition remaining
        IFFVerification1.VALIDATE(IFFVerification1."Highest Credit Usage", 0);
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);
        // IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue",ROUND(LoanHeader."Due Principal"+LoanHeader."Interest Due",1,'=')); //verify again

        //for no intstallment overdue
        CLEAR(noInstallOverdue);
        CLEAR(Amt30);
        CLEAR(Amt60);
        CLEAR(Amt90);
        CLEAR(Amt120);
        CLEAR(Amt150);
        CLEAR(Amt180);
        CLEAR(Amt180more);
        LoanLine1.RESET;
        LoanLine1.SETRANGE("Loan No.", LoanHeader."Loan No.");
        LoanLine1.SETRANGE("Line Cleared", FALSE);
        LoanLine1.SETFILTER("EMI Mature Date", '<%1', TODAY);
        noInstallOverdue := LoanLine1.COUNT;
        IF LoanLine1.FINDSET THEN
            REPEAT
                LoanLine1.CALCFIELDS("Interest Paid", "Principal Paid", "Penalty Paid");
                /*
                    IF (LoanLine1."Delay by No. of Days" > 1 ) AND (LoanLine1."Delay by No. of Days" < 30 ) THEN
                  Amt30 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                IF (LoanLine1."Delay by No. of Days" > 30  ) AND (LoanLine1."Delay by No. of Days" < 60 ) THEN
                  Amt60 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                IF (LoanLine1."Delay by No. of Days" > 60 ) AND (LoanLine1."Delay by No. of Days" < 90 ) THEN
                  Amt90 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                IF (LoanLine1."Delay by No. of Days" > 90 ) AND (LoanLine1."Delay by No. of Days" < 120 ) THEN
                  Amt120 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                IF (LoanLine1."Delay by No. of Days" > 120 ) AND (LoanLine1."Delay by No. of Days" < 150 ) THEN
                  Amt150 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                IF (LoanLine1."Delay by No. of Days" > 150 ) AND (LoanLine1."Delay by No. of Days" < 180 ) THEN
                  Amt180 := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                IF (LoanLine1."Delay by No. of Days" > 180 ) AND (LoanLine1."Delay by No. of Days" < 1000 ) THEN
                  Amt180more := LoanLine1."EMI Amount" -LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                  */ //old
                amtDone := FALSE;

                IF NOT amtDone AND (Amt30 = 0) THEN BEGIN
                    LoanLine1.CALCFIELDS("Interest Paid", "Principal Paid", "Penalty Paid");
                    IF (LoanLine1."Delay by No. of Days" > 1) AND (LoanLine1."Delay by No. of Days" < 30) THEN BEGIN
                        Amt30 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;
                    END;
                END;

                IF NOT (amtDone) AND (Amt60 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 30) > 30) AND ((LoanLine1."Delay by No. of Days" + 30) < 60)) THEN BEGIN
                        Amt60 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;
                    END;
                END;

                IF NOT amtDone AND (Amt90 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 60) > 60) AND ((LoanLine1."Delay by No. of Days" + 60) < 90)) THEN BEGIN
                        Amt90 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND (Amt120 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 90) > 90) AND ((LoanLine1."Delay by No. of Days" + 90) < 120)) THEN BEGIN
                        Amt120 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND (Amt150 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 120) > 120) AND ((LoanLine1."Delay by No. of Days" + 120) < 150)) THEN BEGIN
                        Amt150 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";

                    END;
                END;

                IF NOT amtDone AND (Amt180 = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 150) > 150) AND ((LoanLine1."Delay by No. of Days" + 150) < 180)) THEN BEGIN
                        Amt180 := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND (Amt180more = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 180) > 180) AND ((LoanLine1."Delay by No. of Days" + 180) < 5000)) THEN BEGIN
                        Amt180more += LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;
            UNTIL LoanLine1.NEXT = 0;

        IFFVerification1."Amount OverDue" := IFFVerification1."Amount OverDue 1-30 Days" + IFFVerification1."Amount OverDue 31-60 Days" + IFFVerification1."Amount OverDue 61-90 Days" +
         IFFVerification1."Amount OverDue 91-120 Days" + IFFVerification1."Amount OverDue 121-150 Days" + IFFVerification1."Amount OverDue 151-180 Days" + IFFVerification1."Amount  Overdue 181 or More";


        LoanLine.RESET;
        LoanLine.SETRANGE(LoanLine."Loan No.", LoanHeader."Loan No.");
        LoanLine.SETRANGE(LoanLine."Line Cleared", TRUE);
        IF LoanLine.FINDLAST THEN
            //
            //Agni INC UPG
            IF LoanLine."Last Payment Date" <> 0D THEN BEGIN
                IF LoanLine."Delay by No. of Days" = 0 THEN
                    LoanLine."Delay by No. of Days" := LoanLine."Last Payment Date" - LoanLine."EMI Mature Date";
            END;
        //

        /*IF LoanLine."Last Payment Date" <> 0D THEN BEGIN //prabesh Cmnted
          IF LoanLine."Delay by No. of Days" = 0 THEN
            LoanLine."Delay by No. of Days" := LoanLine."Last Payment Date" - LoanLine."EMI Mature Date";
            END
        ELSE BEGIN
          LoanLineNew.RESET;
          LoanLineNew.SETRANGE(LoanLineNew."Loan No.",LoanHeader."Loan No.");
          LoanLineNew.SETRANGE(LoanLineNew."Line Cleared",TRUE);
          LoanLineNew.SETFILTER(LoanLineNew."Last Payment Date", '<>%1', 0D);
          IF LoanLineNew.FINDLAST THEN
            IF LoanLine."Delay by No. of Days" = 0 THEN
                LoanLine."Delay by No. of Days" := LoanLineNew."Last Payment Date" - LoanLine."EMI Mature Date";
         END;*/
        //Agni INC UPG
        IF LoanLine."Delay by No. of Days" <> 0 THEN BEGIN
            LLForPrecdDate.RESET;
            LLForPrecdDate.SETRANGE("Loan No.", LoanHeader."Loan No.");
            LLForPrecdDate.SETFILTER("EMI Mature Date", '<=%1', TODAY);
            IF LLForPrecdDate.FINDLAST THEN
                IFFVerification1.VALIDATE("Immediate Preceeding Date", dateConversion(LLForPrecdDate."EMI Mature Date"));

            /*  LoanLine.CALCFIELDS("Last Receipt No.");
              PaymentLine.RESET;
              PaymentLine.SETRANGE("G/L Receipt No.",LoanLine."Last Receipt No.");
              IF PaymentLine.FINDFIRST THEN
                IFFVerification1.VALIDATE(IFFVerification1."Last Repay Amount",ROUND(PaymentLine."Principal Paid"+PaymentLine."Interest Paid"+PaymentLine."Penalty Paid",1,'='));
                    IFFVerification1.VALIDATE(IFFVerification1."Date of Last Repay",dateConversion(PaymentLine."Payment Date"));
                    */

            //IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Indicator",LoanHeader."Payment Dealy History Flag");
            IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Indicator", '001');

        END ELSE
            IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Indicator", '002');
        IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Indicator", '002');

        IF IFFVerification1."Amount OverDue" <> 0 THEN BEGIN
            DPDDay := 0;
            LoanLineDPD.RESET;
            LoanLineDPD.SETRANGE("Loan No.", LoanHeader."Loan No.");
            LoanLineDPD.SETFILTER("EMI Mature Date", '<=%1', TODAY);
            LoanLineDPD.SETRANGE("Line Cleared", FALSE);
            IF LoanLineDPD.FINDFIRST THEN BEGIN
                //IF NOT LoanLineDPD."Line Cleared" THEN BEGIN
                DPDDay := TODAY - LoanLineDPD."EMI Mature Date";
                //CODE ADDED FROM AASTHA
                //IF IFFVerification1."Amount OverDue" <> 0 THEN BEGIN
                //CODE ADDED FROM AASTHA
                IF DPDDay > 999 THEN
                    IFFVerification1.VALIDATE("Number of days over due", 999)
                ELSE
                    IFFVerification1.VALIDATE("Number of days over due", DPDDay);
            END;
        END ELSE
            IFFVerification1.VALIDATE("Number of days over due", 0);

        // IF DPDDay > 0 THEN
        //      IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days",0)
        //ELSE
        PDDLoanLine.RESET;
        PDDLoanLine.SETRANGE("Loan No.", LoanHeader."Loan No.");
        PDDLoanLine.SETFILTER("EMI Mature Date", '<=%1', TODAY);
        // PDDLoanLine.SETFILTER("Last Payment Date",'<>%1',0D);
        //  PDDLoanLine.SETRANGE("Line Cleared",TRUE);
        IF PDDLoanLine.FINDLAST THEN BEGIN
            //3/27/23
            IF PDDLoanLine."Line Cleared" THEN BEGIN
                PDDLoanLine.CALCFIELDS("Last Receipt No.");
                PaymentLine.RESET;
                PaymentLine.SETRANGE("G/L Receipt No.", PDDLoanLine."Last Receipt No.");
                IF PaymentLine.FINDFIRST THEN
                    IFFVerification1.VALIDATE(IFFVerification1."Last Repay Amount", ROUND(PaymentLine."Principal Paid" + PaymentLine."Interest Paid" + PaymentLine."Penalty Paid", 1, '='));
                IFFVerification1.VALIDATE(IFFVerification1."Date of Last Repay", dateConversion(PaymentLine."Payment Date"));
            END;
        END;

        //3.27
        IF PaymentLine."Payment Date" <> 0D THEN BEGIN
            PDDLoanLine1.RESET;
            PDDLoanLine1.SETRANGE("Loan No.", LoanHeader."Loan No.");
            PDDLoanLine1.SETFILTER("EMI Mature Date", '<=%1', TODAY);

            IF PDDLoanLine1.FINDLAST THEN BEGIN
                IF (PDDLoanLine1."EMI Mature Date" <> 0D) AND (PDDLoanLine1."Last Payment Date" <> 0D) THEN
                    IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days", PDDLoanLine1."Last Payment Date" - PDDLoanLine1."EMI Mature Date");
            END;
        END; //4.26 ayan dai




        IFFVerification1.VALIDATE(IFFVerification1."No of Installments Overdue", noInstallOverdue);


        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 1-30 Days", ROUND(Amt30, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 31-60 Days", ROUND(Amt60, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 61-90 Days", ROUND(Amt90, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 91-120 Days", ROUND(Amt120, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 121-150 Days", ROUND(Amt150, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount OverDue 151-180 Days", ROUND(Amt180, 1, '='));
        IFFVerification1.VALIDATE(IFFVerification1."Amount  Overdue 181 or More", ROUND(Amt180more, 1, '=')); //26



        IFFVerification1.VALIDATE(IFFVerification1."Assets Classification", FORMAT(LoanHeader."Asset Claasification"));
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Status", LoanHeader."Credit Facility Status");
        IFFVerification1.VALIDATE(IFFVerification1."Credit Facility Closing Date", dateConversion(LoanHeader."Closed Date")); //revisit
        IFFVerification1.VALIDATE(IFFVerification1."Reason for Closure", LoanHeader."Reason for Closure");
        IFFVerification1.VALIDATE(IFFVerification1."Security Coverage Flag", FORMAT(LoanHeader."Security Coverage Flag"));
        IFFVerification1.VALIDATE(IFFVerification1."Legal Action Taken", Customer."Legal Action Taken");
        //IFFVerification1.VALIDATE(IFFVerification1."Info Update On",dateConversion(LoanHeader."Last Date Modified"));
        IFFVerification1.VALIDATE(IFFVerification1."Info Update On", dateConversion(TODAY));

        IF LLForPrecdDate."EMI Mature Date" <> 0D THEN
            IFFVerification1.VALIDATE(IFFVerification1."Info Update On", dateConversion(LLForPrecdDate."EMI Mature Date"));
        IFFVerification1.VALIDATE(IFFVerification1."Time of Update", timeConversion(TIME));


        IF IFFVerification1."Amount OverDue" <> 0 THEN
            IFFVerification1."Payment Delay Days" := 0;

    end;

    local procedure insertAndUpdateCHConsumer(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier CH");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");// not  found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
        IFFVerification1.VALIDATE(IFFVerification1."Date Reported", dateConversion(TODAY));//not found
        IFFVerification1.VALIDATE(IFFVerification1."Installment Due Date", dateConversion(LoanLine."EMI Mature Date"));//verify again
        IFFVerification1.VALIDATE(IFFVerification1."Payment Due Settlment Date", dateConversion(LoanHeader."Payment Receipt Date"));//not found
        IFFVerification1.VALIDATE(IFFVerification1."Payment Delay Days", LoanLine."Delay by No. of Days");
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);
    end;

    local procedure insertAndUpdateCSConsumer(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier CS");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No."); // credit facility number
        IFFVerification1.VALIDATE(IFFVerification1."Customer No.", LoanHeader."Customer No.");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Prev Customer No.", '');// not found
        IFFVerification1.VALIDATE(IFFVerification1."Subject Name", Customer."Subject Name");
        IFFVerification1.VALIDATE(IFFVerification1."Subject Prev Name", Customer."Subject Prev Name");
        IFFVerification1.VALIDATE(IFFVerification1."Citizenship Number", Customer."Citizenship No.");
        IF Customer."Citizenship No." <> '' THEN BEGIN
            Customer.TESTFIELD("Citizenship Issued Date");
            Customer.TESTFIELD("Citizenship Issued District");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."Prev Citizenship Number", Customer."Previous Citizenship No");
        IFFVerification1.VALIDATE(IFFVerification1."Citizenship Issued Date", checkNepaliDate(Customer."Citizenship Issued Date"));
        IFFVerification1.VALIDATE(IFFVerification1."Citizenship Issued District", Customer."Citizenship Issued District");
        IFFVerification1.VALIDATE(IFFVerification1.PAN, Customer.PAN);
        IFFVerification1.VALIDATE(IFFVerification1."Previous PAN", Customer."Previous PAN");
        IFFVerification1.VALIDATE(IFFVerification1."PAN Issue Date", Customer."PAN Issue Date");
        IFFVerification1.VALIDATE(IFFVerification1."PAN Issue District", Customer."PAN Issue District");
        IFFVerification1.VALIDATE(IFFVerification1.Passport, Customer.Passport);
        IFFVerification1.VALIDATE(IFFVerification1."Prev Passport", Customer."Prev Passport");
        IFFVerification1.VALIDATE(IFFVerification1."Passport No. Expiry Date", FORMAT(Customer."Passport Expiry Date"));
        IFFVerification1.VALIDATE(IFFVerification1."Voter ID", Customer."Voter ID");
        IFFVerification1.VALIDATE(IFFVerification1."Prev Voter ID", Customer."Prev Voter ID");
        IFFVerification1.VALIDATE(IFFVerification1."Voter ID no issued Date", Customer."Voter ID issued Date");
        IFFVerification1.VALIDATE(IFFVerification1."IN Embassy Reg No.", Customer."Ind Emb Regd No");
        IFFVerification1.VALIDATE(IFFVerification1."IN Embasssy Reg No. Issue Date", FORMAT(Customer."Indian Ebassy Reg Date"));
        IFFVerification1.VALIDATE(IFFVerification1."Father Name", Customer."Fathers Name");
        IFFVerification1.VALIDATE(IFFVerification1."Grand Father Name", Customer."Grand Father Name");
        IFFVerification1.VALIDATE(IFFVerification1."Spouse1 Name", Customer."Spouse 1 Name");
        IFFVerification1.VALIDATE(IFFVerification1."Spouse2 Name", Customer."Spouse 2 Name");
        IFFVerification1.VALIDATE(IFFVerification1."Mother Name", Customer."Mother's Name");
        IFFVerification1.VALIDATE(IFFVerification1."Subject Nationality", Customer."Subject Nationality");
        IFFVerification1.VALIDATE(IFFVerification1."Marital Status", Customer."Marital Status");
        IFFVerification1.VALIDATE(IFFVerification1."Date of Birth", dateConversion(Customer."Date of Company Redg"));
        IFFVerification1.VALIDATE(IFFVerification1.Gender, Customer.Gender);
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Type", Customer."Address Type");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Line 1", Customer."Address 1 Line 1"); //not found
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Line 2", Customer."Address 1 Line 2"); //not found
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Line 3", Customer."Address 1 Line 3"); //not found
        IFFVerification1.VALIDATE(IFFVerification1."Address1 District", Customer."Address District"); //verify again
        IFFVerification1.VALIDATE(IFFVerification1."Address1 PO Box", Customer."PO Box");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Address1 Country", Customer."Address 1 Country"); //field not found
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Type", Customer."Address 2 Type");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Line 1", Customer."Address 2 Line 1");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Line 2", Customer."Address 2 Line 2");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Line 3", Customer."Address 2 Line 3");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 District", Customer."Address 2 District");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Power BOX", Customer."Address 2 Power Box");
        IFFVerification1.VALIDATE(IFFVerification1."Address 2 Country", Customer."Address 2 Country");
        IFFVerification1.VALIDATE(IFFVerification1."Telephone 1", Customer."Telephone Number 2");// verify again
        IFFVerification1.VALIDATE(IFFVerification1."Telephone Number 2", Customer."Telephone Number 2");// field not found
        IFFVerification1.VALIDATE(IFFVerification1."Mobile Number", Customer."Telephone Number 2");
        IFFVerification1.VALIDATE(IFFVerification1."Business Activity Code", Customer."Business Activity Code");
        IFFVerification1.VALIDATE(IFFVerification1."Fax 1", Customer."Fax 1");//two fax1 exist
        IFFVerification1.VALIDATE(IFFVerification1.Fax2, Customer."Fax 2");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Email Address", Customer."E-Mail");// verify once since e-mail &e-mail2 exist
        IFFVerification1.VALIDATE(IFFVerification1.Group, Customer.Group);
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);
    end;

    local procedure insertAndUpdateESConsumer(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier ES");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
        IFFVerification1.VALIDATE(IFFVerification1."Customer No.", Customer."No.");
        IFFVerification1.VALIDATE(IFFVerification1."Employment Type", Customer."Employment Type");
        IFFVerification1.VALIDATE(IFFVerification1."Employer Name", Customer."Employer Name");
        IFFVerification1.VALIDATE(IFFVerification1."Employement Comm Regd ID", Customer."Employment Commer Register ID");
        IFFVerification1.VALIDATE(IFFVerification1."Subject Employer Address", Customer."Subject Employer Address");
        IFFVerification1.VALIDATE(IFFVerification1.Designation, Customer.Designation);
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);
        IFFVerification1.VALIDATE(IFFVerification1."Monthly Income", removeComma(FORMAT(Customer."Monthly Income")));
    end;

    local procedure insertAndUpdateRSConsumer(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier RS");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        //iffverf2 shown
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
        IFFVerification1.VALIDATE(IFFVerification1."Customer No.", Customer."No.");//verify once
                                                                                   //Related Entity new table Custpmer Related Entity
                                                                                   //control
        IF CustomerRelatedEntity."Related Entities Type" = '001' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RS Father Name");
            CustomerRelatedEntity.TESTFIELD("RS Gurantee Type");
            IF CustomerRelatedEntity."RE Company Registration No." <> '' THEN
                ERROR('You cant enter Company redg No. when Related Entity is 001 for Loan %1', LoanHeader."Loan No.");

        END;
        //control


        CustomerRelatedEntity.TESTFIELD("RS Nature of Relationship");//prev nature of relation
        CustomerRelatedEntity.TESTFIELD("Related Entities Type");
        IFFVerification1.VALIDATE(IFFVerification1."Related Entity Type", CustomerRelatedEntity."Related Entities Type");
        IFFVerification1.VALIDATE(IFFVerification1."Nature of Relationship", CustomerRelatedEntity."RS Nature of Relationship");
        IFFVerification1.VALIDATE(IFFVerification1."Related Entities Name", CustomerRelatedEntity."Related Entities Name");
        IF CustomerRelatedEntity."Related Entities Type" = '002' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RS Legal Status");
            IFFVerification1.VALIDATE(IFFVerification1."Legal Status", CustomerRelatedEntity."RS Legal Status");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."Date of Birth Comp Redg", dateConversion(CustomerRelatedEntity."Related Entity DOB"));// related entity date of birth
        IFFVerification1.VALIDATE(IFFVerification1."RE Comp Redg No.", CustomerRelatedEntity."RE Company Registration No.");//new
        IF CustomerRelatedEntity."RE Company Registration No." <> '' THEN
            CustomerRelatedEntity.TESTFIELD("RE Comp Reg No Issued Auth");
        IFFVerification1.VALIDATE(IFFVerification1."RE Comp Reg No. Issued Auth", CustomerRelatedEntity."RE Comp Reg No Issued Auth"); //new
        IFFVerification1.VALIDATE(IFFVerification1."RE Citizenship No.", CustomerRelatedEntity."RE Citizenship No"); //new
        IF CustomerRelatedEntity."RE Citizenship No" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RE Citizenship No Issued Date");
            CustomerRelatedEntity.TESTFIELD("RE Citizenship No Issued Distr");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."RE Prev Citizenship No.", CustomerRelatedEntity."RE Prev Citizenship No");//new
        IFFVerification1.VALIDATE(IFFVerification1."RE Citizenship No. Issued Date", CustomerRelatedEntity."RE Citizenship No Issued Date");//new
        IFFVerification1.VALIDATE(IFFVerification1."RE Citizen No. Issued District", CustomerRelatedEntity."RE Citizenship No Issued Distr");// new
        IFFVerification1.VALIDATE(IFFVerification1."RE PAN", CustomerRelatedEntity."RE PAN");
        IFFVerification1.VALIDATE(IFFVerification1."RE Previous PAN", CustomerRelatedEntity."RE Prev PAN");
        IF CustomerRelatedEntity."RE PAN" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("RE PAN No Issued Date");
            CustomerRelatedEntity.TESTFIELD("RE PAN No Issued District");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."RE PAN No. Issue Date", CustomerRelatedEntity."RE PAN No Issued Date");
        IFFVerification1.VALIDATE(IFFVerification1."RE PAN issued District", CustomerRelatedEntity."RE PAN No Issued District");//new
                                                                                                                                //16 IF CustomerRelatedEntity.r
        IFFVerification1.VALIDATE(IFFVerification1."RE Passport", CustomerRelatedEntity."RE Passport");//new
        IFFVerification1.VALIDATE(IFFVerification1."RE Previous Passport", CustomerRelatedEntity."RE Prev passport");//new
        IF CustomerRelatedEntity."RE Passport" <> '' THEN
            CustomerRelatedEntity.TESTFIELD("RE Passport Exp Date");
        IFFVerification1.VALIDATE(IFFVerification1."Passport No. Expiry Date", dateConversion(CustomerRelatedEntity."RE Passport Exp Date"));
        IFFVerification1.VALIDATE(IFFVerification1."RE Voter ID", CustomerRelatedEntity."RE Voter ID");//new
        IF CustomerRelatedEntity."RE Voter ID" <> '' THEN
            CustomerRelatedEntity.TESTFIELD("RE Voter ID No Issued Date");
        IFFVerification1.VALIDATE(IFFVerification1."RE Previous Voter ID", CustomerRelatedEntity."RE Prev Voter ID");
        IFFVerification1.VALIDATE(IFFVerification1."RE Voter ID No. Issued Date", CustomerRelatedEntity."RE Voter ID No Issued Date");
        IFFVerification1.VALIDATE(IFFVerification1."IN Embassy Reg No.", Customer."Ind Emb Regd No");// not found-- two reg date was found
        IFFVerification1.VALIDATE(IFFVerification1."IN Embasssy Reg No. Issue Date", FORMAT(Customer."Indian Ebassy Reg Date"));// verify once
        IF CustomerRelatedEntity."Related Entities Type" = '001' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("Percentage of Control");
            IFFVerification1.VALIDATE(IFFVerification1."Percentage of Control", CustomerRelatedEntity."Percentage of Control");
        END ELSE BEGIN
            IFFVerification1.VALIDATE(IFFVerification1."Percentage of Control", CustomerRelatedEntity."Percentage of Control");

            //   IF CustomerRelatedEntity."Percentage of Control" <> 0 THEN //7/24/2023
            // ERROR('Percentancge control should not have value. %1',LoanHeader."Loan No.");
        END;

        IFFVerification1.VALIDATE(IFFVerification1."Guarantee Type", CustomerRelatedEntity."RS Gurantee Type"); //116
        IFFVerification1.VALIDATE(IFFVerification1."Date of Leaving", dateConversion(CustomerRelatedEntity."RS Date of Leaving"));
        IFFVerification1.VALIDATE(IFFVerification1."Father Name", CustomerRelatedEntity."RS Father Name");
        IFFVerification1.VALIDATE(IFFVerification1."Grand Father Name", Customer."Grand Father Name");// not found
        IFFVerification1.VALIDATE(IFFVerification1."Spouse1 Name", Customer."Spouse 1 Name");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Spouse2 Name", Customer."Spouse 2 Name");// not found
        IFFVerification1.VALIDATE(IFFVerification1."Mother Name", Customer."Mother's Name");// not found
        IFFVerification1.VALIDATE(IFFVerification1."Related Indiv Nationality", CustomerRelatedEntity."Related Indiv Nationality");// from new table
        IF CustomerRelatedEntity."Related Entities Type" = '001' THEN
            IFFVerification1.VALIDATE(IFFVerification1."RE Gender", CustomerRelatedEntity."RE Gender");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Type", CustomerRelatedEntity."RE Entities Address Type");//VERIFY ONCE IN IFF
        IFFVerification1.VALIDATE(IFFVerification1."RE Address 1 Line 1", CustomerRelatedEntity."RE Entities Address Line 1"); // both not found
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Line 2", CustomerRelatedEntity."RE Entities Address Line 2"); //new
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Line 3", CustomerRelatedEntity."RE Entities Address Line 3");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address District", CustomerRelatedEntity."RE Entities Address District");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address P.O Box No", CustomerRelatedEntity."RE Entities Addr PO Box No");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Address Country", CustomerRelatedEntity."RE Entities Address Country");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Telephone No.1", CustomerRelatedEntity."RE Entities Telephone No 1");
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Telephone No.2", CustomerRelatedEntity."RE Entities Telephone No 2");
        IFFVerification1.VALIDATE(IFFVerification1."Related Indv. Mobile No.", CustomerRelatedEntity."Related Indiv Mobile No");
        IFFVerification1.VALIDATE(IFFVerification1."Fax 1", Customer."Fax 1");// verify again
        IFFVerification1.VALIDATE(IFFVerification1.Fax2, Customer."Fax 2");// not found
        IFFVerification1.VALIDATE(IFFVerification1."RE Entities Email Address", CustomerRelatedEntity."RE Entities Email Address");
        IFFVerification1.VALIDATE(IFFVerification1.Group, Customer.Group);
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);
    end;

    local procedure insertAndUpdateBRConsumer(var IFFVerification1: Record "33019802"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
        IFFVerification1.VALIDATE(IFFVerification1."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier BR");
        IFFVerification1.VALIDATE(IFFVerification1."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification1.VALIDATE(IFFVerification1."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification1.VALIDATE(IFFVerification1."Loan No.", LoanHeader."Loan No.");
        IFFVerification1.VALIDATE(IFFVerification1."Customer No.", Customer."No.");//verify once
        IFFVerification1.VALIDATE(IFFVerification1."BR Entity Type", CustomerRelatedEntity."BR RE Type");//new one
        IFFVerification1.VALIDATE(IFFVerification1."Nature of Relationship", CustomerRelatedEntity."BR Nature of Relationship");
        CustomerRelatedEntity.TESTFIELD("BR Nature of Relationship");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Name", CustomerRelatedEntity."BR RE Name");// new from table
        IFFVerification1.VALIDATE(IFFVerification1."Legal Status", CustomerRelatedEntity."BR Legal Status");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE DOB/Date of Reg", dateConversion(CustomerRelatedEntity."BR RE DOB/Date of Regd"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Comp Reg No.", CustomerRelatedEntity."BR RE Comp Regd No");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Comp Reg No. Issue Auth", CustomerRelatedEntity."BR RE Comp Regd No Issud Auth");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Citizenship No.", CustomerRelatedEntity."BR RE Citizenship No");
        IF CustomerRelatedEntity."BR RE Citizenship No" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("BR RE Citizenship No Issd Date");
            CustomerRelatedEntity.TESTFIELD("BR RE Citizenship No Issd Dist");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Prev. Citizenship No.", CustomerRelatedEntity."BR RE Prev Citizenship No");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Citizen No. Issued Date", checkNepaliDate(CustomerRelatedEntity."BR RE Citizenship No Issd Date"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Citizen No. Issue Dist", CustomerRelatedEntity."BR RE Citizenship No Issd Dist");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE PAN", CustomerRelatedEntity."BR RE PAN");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Prev. PAN", CustomerRelatedEntity."BR RE Prev PAN");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE PAN No. Issued Date", CustomerRelatedEntity."BR RE PAN No Issud Date");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE PAN Issued District", CustomerRelatedEntity."BR RE PAN Issued District");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Passport", CustomerRelatedEntity."BR RE Passport");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Previous Passport", CustomerRelatedEntity."BR RE Prev Passport");
        IFFVerification1.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);
        //SP
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Passport No. Exp Date", dateConversion(CustomerRelatedEntity."BR RE Passport No Expiry Date"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Voter ID", CustomerRelatedEntity."BR RE Voter ID");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Prev. Voter ID", CustomerRelatedEntity."BR RE Prev Voter ID");
        //IFFVerification1.VALIDATE(IFFVerification1."BR RE Voter ID No. Issued Date",EngNepDate.getNepaliDate()); issued dates
        //IFFVerification1.VALIDATE(IFFVerification1.,CustomerRelatedEntity."BR RE Ind Emb Regd No"); //BR RE Indian Embassy Regstration number
        IFFVerification1.VALIDATE(IFFVerification1."BR RE IN Emb Reg No. Issue Dat", dateConversion(CustomerRelatedEntity."BR RE Ind Emb Reg No Issd Date"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Gender", CustomerRelatedEntity."BR RE Gender");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Percentage of control", CustomerRelatedEntity."BR RE Percenage of Control");// verify once
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Date of Leaving", dateConversion(CustomerRelatedEntity."BR RE Date of Leaving"));
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Father Name", CustomerRelatedEntity."BR RE Father Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Grand Father Name", CustomerRelatedEntity."BR RE Grand Father Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Spouse1 Name", CustomerRelatedEntity."BR RE Spouse 1 Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Spouse2 Name", CustomerRelatedEntity."BR RE Spouse 2 Name");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Mother Name", CustomerRelatedEntity."BR RE Mother Name");
        IF CustomerRelatedEntity."BR RE Type" = '001' THEN BEGIN
            IFFVerification1.VALIDATE(IFFVerification1."BR Nationality", CustomerRelatedEntity."BR Nationality");
            IF CustomerRelatedEntity."BR Legal Status" <> '' THEN
                ERROR('You cant enter legal status while BR related entity is 001 for Loan %1', LoanHeader."Loan No.");
        END ELSE BEGIN
            IFFVerification1.VALIDATE(IFFVerification1."BR Nationality", '');
            CustomerRelatedEntity.TESTFIELD("BR Legal Status");
        END;
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Type", CustomerRelatedEntity."BR RE Address Type");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Line 1", CustomerRelatedEntity."BR RE Address Line 1");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Line 2", CustomerRelatedEntity."BR RE Address Line 2");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Address Line 3", CustomerRelatedEntity."BR RE Address Line 3");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE District", CustomerRelatedEntity."BR RE District");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE P.O. Box", CustomerRelatedEntity."BR RE PO BOX");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Country", CustomerRelatedEntity."BR RE Country");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Telephone No. 1", CustomerRelatedEntity."BR RE Telephone No 1");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Telephone No. 2", CustomerRelatedEntity."BR RE Telephone No 2");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Mobile No.", CustomerRelatedEntity."BR RE Mobile No");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Fax 1", CustomerRelatedEntity."BR RE Fax1");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Fax2", CustomerRelatedEntity."BR RE Fax2");
        IFFVerification1.VALIDATE(IFFVerification1."BR RE Email", CustomerRelatedEntity."BR RE Email");
        IFFVerification1.VALIDATE(IFFVerification1.Group, Customer.Group);
    end;

    local procedure insertAndUpdateSSConsumer(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        Customer.TESTFIELD("Related Entity Number");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN;
        IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier SS");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");// not found
        IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");
        IFFVerification2.VALIDATE(IFFVerification2."Customer Number", Customer."No.");
        IFFVerification2.VALIDATE(IFFVerification2."Type of Security", CustomerRelatedEntity."SS Type of Security");
        IFFVerification2.VALIDATE(IFFVerification2."Security Ownership Type", CustomerRelatedEntity."SS Security Ownership Type");
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Type", CustomerRelatedEntity."Security Valuator Type");
        IFFVerification2.VALIDATE(IFFVerification2."Description of Security", CustomerRelatedEntity."Description Of Security");//
        IFFVerification2.VALIDATE(IFFVerification2."Nature of Charge", CustomerRelatedEntity."Nature of Charge");//not
        IFFVerification2.VALIDATE(IFFVerification2."Security Coverage Percentage", FORMAT(CustomerRelatedEntity."Security Coverage Percentage"));//not
        IFFVerification2.VALIDATE(IFFVerification2."Latest Value of Security", CustomerRelatedEntity."Latest Value of Security");//not
        IF Customer."Date of Birth" > CustomerRelatedEntity."Date of Latest Valuation" THEN
            ERROR('You cannot enter Date of valaution later than DOB.');
        IFFVerification2.VALIDATE(IFFVerification2."Date of Latest Valuation", dateConversion(CustomerRelatedEntity."Date of Latest Valuation"));// not
        IFFVerification2.VALIDATE("File Type", IFFVerification2."File Type"::Consumer);

    end;

    local procedure insertAndUpdateVSConsumer(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062"; CustomerRelatedEntity: Record "33019804")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
    begin
        KSKLSetup.GET;
        IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier VS");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");
        IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");
        IFFVerification2.VALIDATE(IFFVerification2."Customer Number", CustomerRelatedEntity."Valuator No.");
        CustomerRelatedEntity.TESTFIELD("Valuator No."); //13
        IFFVerification2.VALIDATE(IFFVerification2."Previous Customer No", '');//not found
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Entity Type", CustomerRelatedEntity."Valuator Entity Type");
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Entity's Name", CustomerRelatedEntity."Valuator Entities Name");
        IFFVerification2.VALIDATE(IFFVerification2."Legal Status", CustomerRelatedEntity."VS Legal Status");
        IFFVerification2.VALIDATE(IFFVerification2."VE DOB/Comp Reg Date", dateConversion(CustomerRelatedEntity."VE DOB/Comp Regd Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VE Comp Reg No.", CustomerRelatedEntity."VE Comp Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VE Comp Reg No. Issue Auth", CustomerRelatedEntity."VE Comp Regd No Issud Auth");
        IFFVerification2.VALIDATE(IFFVerification2."VE Citizenship No", CustomerRelatedEntity."VE Citizenship No");
        IF CustomerRelatedEntity."VE Citizenship No" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("VE Citizenship No Issud Date");
            CustomerRelatedEntity.TESTFIELD("VE Citizenship No Issud Distr");
        END;
        IFFVerification2.VALIDATE(IFFVerification2."VE Previous Citizenship No.", CustomerRelatedEntity."VE Prev Citizenship No");
        IFFVerification2.VALIDATE(IFFVerification2."VE Citizenship No. Issued Date", CustomerRelatedEntity."VE Citizenship No Issud Date");
        IFFVerification2.VALIDATE(IFFVerification2."VE Citizenship No. Issued Dist", CustomerRelatedEntity."VE Citizenship No Issud Distr");
        IFFVerification2.VALIDATE(IFFVerification2."VE PAN", CustomerRelatedEntity."VE PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VE Prev PAN", CustomerRelatedEntity."VE Prev PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VE PAN No. Issued Date", CustomerRelatedEntity."VE PAN No Issued Date");
        IFFVerification2.VALIDATE(IFFVerification2."VE PAN No. Isueed District", CustomerRelatedEntity."VE PAN No Issued Dist");
        IFFVerification2.VALIDATE(IFFVerification2."VE Passport", CustomerRelatedEntity."VE Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VE Previous Passport", CustomerRelatedEntity."VE Prev Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VE Passport No. Exp Date", dateConversion(CustomerRelatedEntity."VE Passport No Expiry Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VE Voter ID", CustomerRelatedEntity."VE Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VE Prev Voter ID", CustomerRelatedEntity."VE prev Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VE Voter ID No. Issued Date", CustomerRelatedEntity."VE voter ID No Issued Date");
        IFFVerification2.VALIDATE(IFFVerification2."VE IN EMB Reg No.", CustomerRelatedEntity."VE Ind Emb Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VE IN EMB Reg No. Issue Date", dateConversion(CustomerRelatedEntity."VE Ind Emb Regd No Issud Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VE Gender", CustomerRelatedEntity."VE Gender");
        IFFVerification2.VALIDATE(IFFVerification2."VE Father's Name", CustomerRelatedEntity."VE Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Grand Father's Name", CustomerRelatedEntity."VE Grand Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Spouse1 Name", CustomerRelatedEntity."VE Spouse 1 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Spouse2 Name", CustomerRelatedEntity."VE Spouse 2 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Mother's Name", CustomerRelatedEntity."VE Mother Name");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Type", CustomerRelatedEntity."VE Address Type");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Line 1", CustomerRelatedEntity."VE Address Line1");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Line 2", CustomerRelatedEntity."VE Address Line2");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Line 3", CustomerRelatedEntity."VE Address Lne3");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address District", CustomerRelatedEntity."VE Address District");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address P.O. Box", CustomerRelatedEntity."VE Address PO Box");
        IFFVerification2.VALIDATE(IFFVerification2."VE Address Country", CustomerRelatedEntity."VE Address Country");
        IFFVerification2.VALIDATE(IFFVerification2."VE Telephone No. 1", CustomerRelatedEntity."VE Telephone Number1");
        IFFVerification2.VALIDATE(IFFVerification2."VE Telephone No. 2", CustomerRelatedEntity."VE Telephone Number2");
        IFFVerification2.VALIDATE(IFFVerification2."VE Mobile No.", COPYSTR(CustomerRelatedEntity."VE Mobile Number", 1, 10));
        IFFVerification2.VALIDATE(IFFVerification2."VE Fax 1", CustomerRelatedEntity."VE Fax1");
        IFFVerification2.VALIDATE(IFFVerification2."VE Fax 2", CustomerRelatedEntity."VE Fax2");
        IFFVerification2.VALIDATE(IFFVerification2."VE Email", CustomerRelatedEntity."VE Email");
        IFFVerification2.VALIDATE(IFFVerification2.Group, '');//not found
        IFFVerification2.VALIDATE("File Type", IFFVerification2."File Type"::Consumer);
    end;

    local procedure insertAndUpdateVRConsumer(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        IFFVerification1: Record "33019802";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        Customer.TESTFIELD("Related Entity Number");
        IF CustomerRelatedEntity.GET(Customer."Related Entity Number") THEN
            IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier VR");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification2.VALIDATE(IFFVerification2."Data Provider Branch ID", KSKLSetup."Branch Id");//not found
        IFFVerification2.VALIDATE(IFFVerification2."Credit Facility Number", LoanHeader."Loan No.");//not found
        IFFVerification2.VALIDATE(IFFVerification2."Customer Number", CustomerRelatedEntity."Valuator No.");
        IFFVerification2.VALIDATE(IFFVerification2."Valuator Rltn Entity Type", CustomerRelatedEntity."Valuator Reltn Entity Type");//new
        IFFVerification2.VALIDATE(IFFVerification2."Nature of Relationship", CustomerRelatedEntity."VR Nature of Relationship");
        IFFVerification2.VALIDATE(IFFVerification2."VR Name", CustomerRelatedEntity."VR Name");//new
        IFFVerification2.VALIDATE(IFFVerification2."Legal Status", Customer."Legal Status");
        IFFVerification2.VALIDATE(IFFVerification2."VR DOB/Date of Reg", dateConversion(CustomerRelatedEntity."VR DOB/Date of Regd"));
        IFFVerification2.VALIDATE(IFFVerification2."VR BE Comp Reg No.", CustomerRelatedEntity."VR BE Comp Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VR BE Comp Reg No. Issued Auth", CustomerRelatedEntity."VR BE Comp Regd No Issud Auth");
        IFFVerification2.VALIDATE(IFFVerification2."VR Indv. Citizenship No.", CustomerRelatedEntity."Valuator Indiv Reltn CitizenNo");
        IF CustomerRelatedEntity."Valuator Indiv Reltn CitizenNo" <> '' THEN BEGIN
            CustomerRelatedEntity.TESTFIELD("VRE Citizenship No Issud Date");
            CustomerRelatedEntity.TESTFIELD("VRE Citizenship No Issud Dist");
        END;
        IFFVerification2.VALIDATE(IFFVerification2."VR Entity's Prev. Citizen No.", CustomerRelatedEntity."VRE Prev Citizenship No");
        IFFVerification2.VALIDATE(IFFVerification2."VR Entity CitizenNo IssueDate", CustomerRelatedEntity."VRE Citizenship No Issud Date");
        IFFVerification2.VALIDATE(IFFVerification2."VR Entity CitizenNo IssueDistr", CustomerRelatedEntity."VRE Citizenship No Issud Dist");
        IFFVerification2.VALIDATE(IFFVerification2."VRE PAN", CustomerRelatedEntity."VRE PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Prev PAN", CustomerRelatedEntity."VRE Prev PAN");
        IFFVerification2.VALIDATE(IFFVerification2."VRE PAN No. Issued Date", dateConversion(CustomerRelatedEntity."VRE PAN No Issud Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VRE BE PAN issued District", CustomerRelatedEntity."VRE BE PAN issud District");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Passport", CustomerRelatedEntity."VRE Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Previous Passport", CustomerRelatedEntity."VRE Prev Passport");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Passport No. Exp Date", dateConversion(CustomerRelatedEntity."VRE Passport No Exp Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VRE Voter ID", CustomerRelatedEntity."VRE Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Prev. Voter ID", CustomerRelatedEntity."VRE Prev Voter ID");
        IFFVerification2.VALIDATE(IFFVerification2."VRE Voter ID No. Issued Date", dateConversion(CustomerRelatedEntity."VRE Voter ID No Issud Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VRE IN EMB Reg No.", CustomerRelatedEntity."VRE Ind Emb Regd No");
        IFFVerification2.VALIDATE(IFFVerification2."VRE IN EMB Reg Issue Date", dateConversion(CustomerRelatedEntity."VRE Ind Emb Regd No Issd Date"));
        IFFVerification2.VALIDATE(IFFVerification2."VR Gender", CustomerRelatedEntity."VR Gender");
        IFFVerification2.VALIDATE(IFFVerification2."VR Percentage of Control", CustomerRelatedEntity."VR Percentage of control");
        IFFVerification2.VALIDATE(IFFVerification2."VR Date of Leaving", dateConversion(CustomerRelatedEntity."VR Date of Leaving"));
        IFFVerification2.VALIDATE(IFFVerification2."VR Father's Name", CustomerRelatedEntity."VR Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Grand Father's Name", CustomerRelatedEntity."VR Grand Father Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Spouse1 Name", CustomerRelatedEntity."VR Spouse1 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Spouse2 Name", CustomerRelatedEntity."Vr Spouse2 Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Mother's Name", CustomerRelatedEntity."VR Mother Name");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Type", CustomerRelatedEntity."VR Address Type");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Line 1", CustomerRelatedEntity."VR Address Line1");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Line 2", CustomerRelatedEntity."VR Address Line2");
        IFFVerification2.VALIDATE(IFFVerification2."VR Address Line 3", CustomerRelatedEntity."VR Address Line3");
        IFFVerification2.VALIDATE(IFFVerification2."VR District", CustomerRelatedEntity."VR District");
        IFFVerification2.VALIDATE(IFFVerification2."VR PO BOX", CustomerRelatedEntity."VR PO Box");
        IFFVerification2.VALIDATE(IFFVerification2."VR Country", CustomerRelatedEntity."VR Country");
        IFFVerification2.VALIDATE(IFFVerification2."VR Telephone No.1", CustomerRelatedEntity."VR Telephone No.1");
        IFFVerification2.VALIDATE(IFFVerification2."VR Telephone No.2", CustomerRelatedEntity."VR Telephone No.2");
        IFFVerification2.VALIDATE(IFFVerification2."VR Mobile No.", COPYSTR(CustomerRelatedEntity."VR Mobile Number", 1, 10));
        IFFVerification2.VALIDATE(IFFVerification2."VR Fax 1", CustomerRelatedEntity."VR Fax1");
        IFFVerification2.VALIDATE(IFFVerification2."VR Fax 2", CustomerRelatedEntity."VR Fax2");
        IFFVerification2.VALIDATE(IFFVerification2."VR Email", CustomerRelatedEntity."VR Email");
        IFFVerification2.VALIDATE(IFFVerification2.Group, Customer.Group);
        IFFVerification2.VALIDATE("File Type", IFFVerification1."File Type"::Consumer);
    end;

    local procedure insertAndUpdateTLConsumer(var IFFVerification2: Record "33019803"; LoanHeader: Record "33020062")
    var
        LoanLine: Record "33020063";
        Customer: Record "18";
        KSKLSetup: Record "33019801";
        CustomerRelatedEntity: Record "33019804";
    begin
        KSKLSetup.GET;
        Customer.GET(LoanHeader."Customer No.");
        IFFVerification2.VALIDATE(IFFVerification2."Consumer Segment Identifier", KSKLSetup."Consumer Segment Identifier TL");
        IFFVerification2.VALIDATE(IFFVerification2."Data Prov Identification No.", KSKLSetup."Identification Number");
        IFFVerification2.VALIDATE("File Type", IFFVerification2."File Type"::Consumer);
    end;

    [Scope('Internal')]
    procedure executeConsumer()
    begin
        insertAndUpdateHDLoanwiseForConsumer;
        insertAndUpdateCFLoanwiseForConsumer;
        insertAndUpdateCHLoanwiseForConsumer;
        insertAndUpdateCSLoanwiseForConsumer; //rn
        insertAndUpdateESLoanwiseForConsumer;
        insertAndUpdateRSLoanwiseForConsumer;
        insertAndUpdateBRLoanwiseForConsumer;
        insertAndUpdateSSLoanwiseForConsumer;
        insertAndUpdateVSLoanwiseForConsumer;
        insertAndUpdateVRLoanwiseForConsumer;
        insertAndUpdateTLLoanwiseForConsumer;
    end;

    [Scope('Internal')]
    procedure executeCommercial()
    begin
        insertAndUpdateHDLoanwiseCommercial;//>>these are for commercial
        insertAndUpdateCFLoanwiseCommercial;
        insertAndUpdateCHLoanwiseCommercial;
        insertAndUpdateCSLoanwiseCommercial;
        insertAndUpdateRSLoanwiseCommercial;
        insertAndUpdateBRLoanwiseCommercial;
        insertAndUpdateSSLoanwiseCommercial;
        insertAndUpdateVSLoanwiseCommercial;
        insertAndUpdateVRLoanwiseCommercial;
        insertAndUpdateTLLoanwiseCommercial;//<<these are for commercial
    end;

    [Scope('Internal')]
    procedure getAllOverduesUpdated(LoanHdr: Record "33020062")
    var
        LoanLine1: Record "33020063";
        noInstallOverdue: Integer;
        Amt30: Decimal;
        Amt60: Decimal;
        Amt90: Decimal;
        Amt120: Decimal;
        Amt150: Decimal;
        Amt180: Decimal;
        Amt180more: Decimal;
        LoanLineDPD: Record "33020063";
        DPDDay: Integer;
        PaymentLine: Record "33020072";
        LLForPrecdDate: Record "33020063";
        LoanLine: Record "33020063";
        amtDone: Boolean;
    begin

        // "Amount Overdue KSKL" := ROUND("Due Principal"+"Interest Due"+"Penalty Due",1,'=');
        CLEAR(Amt180more);

        LoanLine1.RESET;
        LoanLine1.SETRANGE("Loan No.", LoanHdr."Loan No.");
        LoanLine1.SETRANGE("Line Cleared", FALSE);
        LoanLine1.SETFILTER("EMI Mature Date", '<%1', TODAY);
        noInstallOverdue := LoanLine1.COUNT;
        IF LoanLine1.FINDSET THEN
            REPEAT
                amtDone := FALSE;

                IF NOT amtDone AND ("Amount Overdue 1 30 KSKL" = 0) THEN BEGIN
                    LoanLine1.CALCFIELDS("Interest Paid", "Principal Paid", "Penalty Paid");
                    IF (LoanLine1."Delay by No. of Days" > 1) AND (LoanLine1."Delay by No. of Days" < 30) THEN BEGIN
                        "Amount Overdue 1 30 KSKL" := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;
                    END;
                END;

                IF NOT (amtDone) AND ("Amount Overdue 31 60 KSKL" = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 30) > 30) AND ((LoanLine1."Delay by No. of Days" + 30) < 60)) THEN BEGIN
                        "Amount Overdue 31 60 KSKL" := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;
                    END;
                END;

                IF NOT amtDone AND ("Amount Overdue 61 90 KSKL" = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 60) > 60) AND ((LoanLine1."Delay by No. of Days" + 60) < 90)) THEN BEGIN
                        "Amount Overdue 61 90 KSKL" := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND ("Amount Overdue 91 120 KSKL" = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 90) > 90) AND ((LoanLine1."Delay by No. of Days" + 90) < 120)) THEN BEGIN
                        "Amount Overdue 91 120 KSKL" := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND ("Amount Overdue 121 150 KSKL" = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 120) > 120) AND ((LoanLine1."Delay by No. of Days" + 120) < 150)) THEN BEGIN
                        "Amount Overdue 121 150 KSKL" := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";

                    END;
                END;

                IF NOT amtDone AND ("Amount Overdue 151 180 KSKL" = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 150) > 150) AND ((LoanLine1."Delay by No. of Days" + 150) < 180)) THEN BEGIN
                        "Amount Overdue 151 180 KSKL" := LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

                IF NOT amtDone AND ("Amount Overdue 181 Above KSKL" = 0) THEN BEGIN
                    IF (((LoanLine1."Delay by No. of Days" + 180) > 180) AND ((LoanLine1."Delay by No. of Days" + 180) < 5000)) THEN BEGIN
                        "Amount Overdue 181 Above KSKL" += LoanLine1."EMI Amount" - LoanLine1."Principal Paid" - LoanLine1."Interest Paid";
                        amtDone := TRUE;

                    END;
                END;

            UNTIL LoanLine1.NEXT = 0;

        //26

        "Amount Overdue KSKL" := "Amount Overdue 1 30 KSKL" + "Amount Overdue 31 60 KSKL" + "Amount Overdue 61 90 KSKL" + "Amount Overdue 91 120 KSKL" +
        "Amount Overdue 121 150 KSKL" + "Amount Overdue 151 180 KSKL" + "Amount Overdue 181 Above KSKL";

        LoanLine.RESET;
        LoanLine.SETRANGE(LoanLine."Loan No.", LoanHdr."Loan No.");
        LoanLine.SETRANGE(LoanLine."Line Cleared", TRUE);
        IF LoanLine.FINDLAST THEN
            LoanLine.CALCFIELDS("Last Receipt No.");
        PaymentLine.RESET;
        PaymentLine.SETRANGE("G/L Receipt No.", LoanLine."Last Receipt No.");
        IF PaymentLine.FINDFIRST THEN;
        "Last Repayment Amount KSKL" := ROUND(PaymentLine."Principal Paid" + PaymentLine."Interest Paid" + PaymentLine."Penalty Paid", 1, '=');
        "Date of Lastpay KSKL" := PaymentLine."Payment Date";

        IF LoanLine."Delay by No. of Days" <> 0 THEN BEGIN
            LLForPrecdDate.RESET;
            LLForPrecdDate.SETFILTER("EMI Mature Date", '<=%1', TODAY);
            IF LLForPrecdDate.FINDLAST THEN;
            "Immidate Preceeding Date KSKL" := LLForPrecdDate."EMI Mature Date";
        END;
        //we dont need

        DPDDay := 0;
        LoanLineDPD.RESET;
        LoanLineDPD.SETRANGE("Loan No.", LoanHdr."Loan No.");
        LoanLineDPD.SETFILTER("EMI Mature Date", '<=%1', TODAY);
        LoanLineDPD.SETRANGE("Line Cleared", FALSE);
        IF LoanLineDPD.FINDFIRST THEN
            DPDDay := TODAY - LoanLineDPD."EMI Mature Date";

        IF DPDDay > 999 THEN
            "No of Days Overdue KSKL" := 999
        ELSE
            "No of Days Overdue KSKL" := DPDDay;


        IF DPDDay > 0 THEN
            "Payemnt Delay Days KSKL" := 0
        ELSE
            IF (LLForPrecdDate."EMI Mature Date" <> 0D) AND (LoanHdr."Last Payment Date" <> 0D) THEN
                "Payemnt Delay Days KSKL" := (LLForPrecdDate."EMI Mature Date" - LoanHdr."Last Payment Date");

        IF "Payemnt Delay Days KSKL" = 0 THEN
            "Payemnt Delay Days KSKL" := LoanLine."Delay by No. of Days";

        "No of Payemnt Installments KSK" := "Due Installments";

        LoanHdr.MODIFY;
    end;

    [Scope('Internal')]
    procedure beforeImportTheData()
    var
        IFFVerification1: Record "33019802";
        IFFVerification2: Record "33019803";
    begin
        IFFVerification1.DELETEALL;
        IFFVerification2.DELETEALL;
    end;
}

