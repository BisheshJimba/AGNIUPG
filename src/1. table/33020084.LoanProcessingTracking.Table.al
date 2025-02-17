table 33020084 "Loan Processing Tracking"
{

    fields
    {
        field(1; "Application No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(10; Components; Code[20])
        {
            TableRelation = "General Master" WHERE(Category = CONST(VEHICLE LOAN),
                                                    Sub Category=CONST(COMPONENTS),
                                                    Disable=FILTER(No));

            trigger OnValidate()
            begin
                GeneralMaster.RESET;
                GeneralMaster.SETRANGE(Category,'Vehicle Loan');
                GeneralMaster.SETRANGE("Sub Category",'Components');
                GeneralMaster.SETRANGE(Code,Components);
                IF GeneralMaster.FINDFIRST THEN
                  "Components Description" :=  GeneralMaster.Description;
            end;
        }
        field(11;"Components Description";Text[150])
        {
        }
        field(12;Date;Date)
        {
        }
        field(13;"Processing Time";Decimal)
        {
        }
        field(14;"User Id";Code[50])
        {
        }
        field(15;Remarks;Text[150])
        {
        }
        field(16;Processed;Boolean)
        {

            trigger OnValidate()
            begin
                Date := TODAY;
                "User Id" := USERID;
                IF Processed THEN BEGIN

                  LineNoLast := 0;
                  LineNoSecondLast := 0;
                  TempLineNo := 0;
                  GetLineNo(LineNoLast,LineNoSecondLast);
                  IF ("Line No." = LineNoLast) OR ("Line No." = LineNoSecondLast) THEN    //any of the last two lines can be processed first.
                    TempLineNo  := LineNoSecondLast
                  ELSE
                    TempLineNo := "Line No.";

                  LoanProcTracking.RESET;
                  LoanProcTracking.SETRANGE("Application No.","Application No.");
                  LoanProcTracking.SETFILTER("Line No.", '<%1',TempLineNo);
                  IF LoanProcTracking.FINDLAST THEN BEGIN
                    IF LoanProcTracking.Date <> 0D THEN
                      "Processing Time" := TODAY - LoanProcTracking.Date;

                    IF "Processing Time" < 0 THEN
                      "Processing Time" := 0;

                    LoanProcTracking.TESTFIELD(Processed);
                  END;
                END ELSE BEGIN
                  Date := 0D;
                  "Processing Time" := 0;
                  "User Id" := '';
                END;
            end;
        }
    }

    keys
    {
        key(Key1;"Application No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        LoanProcTracking: Record "33020084";
        GeneralMaster: Record "33020061";
        LoanProcessTracking: Record "33020084";
        LineNoLast: Integer;
        LineNoSecondLast: Integer;
        LineNoThirdLast: Integer;
        TempLineNo: Integer;

    [Scope('Internal')]
    procedure GetLineNo(var LineNoLast_: Integer;var LineNoSecondLast_: Integer)
    begin
        LoanProcessTracking.RESET;
        LoanProcessTracking.SETRANGE("Application No.","Application No.");
        IF LoanProcessTracking.FINDLAST THEN BEGIN
          LineNoLast := LoanProcessTracking."Line No.";
          LoanProcessTracking.NEXT(-1);
          LineNoSecondLast := LoanProcessTracking."Line No.";
        END;
    end;
}

