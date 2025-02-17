page 33019979 "Cheque Inventory"
{
    // Name        Version         Date        Description
    // ***********************************************************
    //             CTS6.1.2        24-09-12    Page Courier Tracking Header
    // Ravi        CNY1.0          24-09-12    Previous Page "Courier Tracking Header" has been changed to "Check Inventory"

    PageType = Worksheet;

    layout
    {
        area(content)
        {
            group()
            {
                field(BankAcc; BankAcc)
                {
                    Caption = 'Bank Account No.';
                    TableRelation = "Bank Account";

                    trigger OnValidate()
                    begin
                        IF BankAccount_G.GET(BankAcc) THEN
                            BankName := BankAccount_G.Name;

                        ValidateChequeNo(BankAcc, ChequeNo);
                    end;
                }
                field(BankName; BankName)
                {
                    Caption = 'Bank Name';
                    Editable = false;
                }
                field(ChequeNo; ChequeNo)
                {
                    Caption = 'Cheque No.';

                    trigger OnValidate()
                    begin
                        ChequeNo2 := ChequeNo;
                        ValidateChequeNo(BankAcc, ChequeNo);
                    end;
                }
                field("No.ofCheques"; "No.ofCheques")
                {
                    Caption = 'No. Of Cheques';
                }
                field(NoOfBundles; NoOfBundles)
                {
                    Caption = 'No. Of Bundles';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate Cheques")
            {
                Caption = 'Generate Cheques';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    IF (BankAcc = '') OR (ChequeNo = '') OR ("No.ofCheques" = 0) OR (NoOfBundles = 0) THEN
                        ERROR('Bank Account/Cheque No./No.of Cheques/No. of Bundles should be filled');


                    CheckEnt_G.RESET;
                    IF CheckEnt_G.FINDLAST THEN
                        EntryNo := CheckEnt_G."Entry No."
                    ELSE
                        EntryNo := 0;

                    GetLastCheReg.RESET;
                    IF GetLastCheReg.FINDLAST THEN
                        LastNo := GetLastCheReg."No."
                    ELSE
                        LastNo := 0;

                    // to splint the bundles

                    J := NoOfBundles;
                    REPEAT
                        Bundle[J] := ROUND(("No.ofCheques" - I) / J, 1, '=');
                        I += ROUND(("No.ofCheques" - I) / J, 1, '=');
                        J -= 1;
                    UNTIL J = 0;

                    // to insert cheque registers

                    ChequeReg_G.INIT;
                    ChequeReg_G."No." := LastNo + 1;
                    ChequeReg_G."From Entry No." := EntryNo + 1;
                    ChequeReg_G."Creation Date" := TODAY;
                    ChequeReg_G."Bank Account No." := BankAcc;
                    ChequeReg_G."User ID" := USERID;
                    ChequeReg_G.INSERT;

                    I := 1;
                    BundleNo := 'BUND0001';

                    // to insert cheque entries

                    REPEAT
                        Cnt += 1;

                        EntryCountforEachBundle += 1;

                        CheckEntInsert_G.INIT;
                        CheckEntInsert_G."Entry No." := EntryNo + 1;

                        IF Cnt = 1 THEN
                            CheckEntInsert_G."Cheque No." := ChequeNo2
                        ELSE
                            CheckEntInsert_G."Cheque No." := INCSTR(ChequeNo2);

                        ValidateChequeNo(BankAcc, CheckEntInsert_G."Cheque No.");
                        CheckEntInsert_G."Bank No." := BankAcc;
                        CheckEntInsert_G."Bank Name" := BankName;
                        CheckEntInsert_G."Created Date" := TODAY;

                        IF EntryCountforEachBundle > Bundle[I] THEN BEGIN
                            EntryCountforEachBundle := 1;
                            I += 1;
                            BundleNo := INCSTR(BundleNo);
                        END;

                        CheckEntInsert_G."Bundle No." := BundleNo;
                        CheckEntInsert_G.INSERT;

                        EntryNo := CheckEntInsert_G."Entry No.";
                        ChequeNo2 := CheckEntInsert_G."Cheque No.";

                    UNTIL Cnt = "No.ofCheques";

                    // to modify the to enrty no in registers

                    CheckEnt_G.RESET;
                    IF CheckEnt_G.FINDLAST THEN BEGIN
                        ChequeReg_G."To Entry No." := CheckEnt_G."Entry No.";
                        ChequeReg_G.MODIFY;
                    END;

                    ClearValues;
                    MESSAGE('Cheques has been Generated');
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        BankAcc: Code[20];
        BankName: Text[50];
        ChequeNo: Code[30];
        ChequeNo2: Code[30];
        "No.ofCheques": Integer;
        EntryNo: Integer;
        Cnt: Integer;
        CheckEnt_G: Record "33019971";
        CheckEntInsert_G: Record "33019971";
        BankAccount_G: Record "270";
        ChequeReg_G: Record "33019972";
        GetLastCheReg: Record "33019972";
        LastNo: Integer;
        NoOfBundles: Integer;
        Bundle: array[100] of Integer;
        I: Integer;
        J: Integer;
        EntryCountforEachBundle: Integer;
        BundleNo: Code[20];

    [Scope('Internal')]
    procedure ClearValues()
    begin
        CLEAR(BankAcc);
        CLEAR(ChequeNo);
        CLEAR("No.ofCheques");
        CLEAR(Cnt);
        CLEAR(NoOfBundles);
        CLEAR(Bundle);
        CLEAR(I);
        CLEAR(J);
        CLEAR(EntryCountforEachBundle);
        CLEAR(BundleNo);
    end;

    [Scope('Internal')]
    procedure ValidateChequeNo(BankAcc_P: Code[20]; ChequeNo_P: Code[30])
    begin
        CheckEnt_G.RESET;
        CheckEnt_G.SETRANGE("Bank No.", BankAcc_P);
        CheckEnt_G.SETRANGE("Cheque No.", ChequeNo_P);
        IF CheckEnt_G.FINDFIRST THEN BEGIN
            CLEAR(Cnt);
            ERROR('Cheque %1 already exists', CheckEnt_G."Cheque No.");
        END
    end;
}

