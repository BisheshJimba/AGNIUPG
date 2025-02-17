page 33020414 "Application New List"
{
    CardPageID = "Application New Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020382;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; "Application No.")
                {
                }
                field("Vacancy No."; "Vacancy No.")
                {
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("Position Applied"; "Position Applied")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(DOB; DOB)
                {
                }
                field("Marital Status"; "Marital Status")
                {
                }
                field(Gender; Gender)
                {
                }
                field(Nationality; Nationality)
                {
                }
                field(P_WardNo; P_WardNo)
                {
                }
                field(P_Vdc_Np; P_Vdc_Np)
                {
                }
                field(P_District; P_District)
                {
                }
                field(T_WardNo; T_WardNo)
                {
                }
                field(T_Vdc_Np; T_Vdc_Np)
                {
                }
                field(T_District; T_District)
                {
                }
                field(Email; Email)
                {
                }
                field(Telephone; Telephone)
                {
                }
                field(CellPhone; CellPhone)
                {
                }
                field(M_Faculty; M_Faculty)
                {
                }
                field(M_College; M_College)
                {
                }
                field(M_University; M_University)
                {
                }
                field(M_Percentage; M_Percentage)
                {
                }
                field(M_PassedYear; M_PassedYear)
                {
                }
                field(B_Faculty; B_Faculty)
                {
                }
                field(B_College; B_College)
                {
                }
                field(B_University; B_University)
                {
                }
                field(B_Percentage; B_Percentage)
                {
                }
                field(B_PassedYear; B_PassedYear)
                {
                }
                field(I_Faculty; I_Faculty)
                {
                }
                field(I_College; I_College)
                {
                }
                field(I_University; I_University)
                {
                }
                field(I_Percentage; I_Percentage)
                {
                }
                field(I_PassedYear; I_PassedYear)
                {
                }
                field(S_Faculty; S_Faculty)
                {
                }
                field(S_College; S_College)
                {
                }
                field(S_University; S_University)
                {
                }
                field(S_Percentage; S_Percentage)
                {
                }
                field(S_PassedYear; S_PassedYear)
                {
                }
                field(O_Faculty; O_Faculty)
                {
                }
                field(O_College; O_College)
                {
                }
                field(O_University; O_University)
                {
                }
                field(O_Percentage; O_Percentage)
                {
                }
                field(O_PassedYear; O_PassedYear)
                {
                }
                field(WE1_SN; WE1_SN)
                {
                }
                field(WE1_Orgnization; WE1_Orgnization)
                {
                }
                field(WE1_Department; WE1_Department)
                {
                }
                field(WE1_Position; WE1_Position)
                {
                }
                field(WE1_Duration; WE1_Duration)
                {
                }
                field(WE2_SN; WE2_SN)
                {
                }
                field(WE2_Orgnization; WE2_Orgnization)
                {
                }
                field(WE2_Department; WE2_Department)
                {
                }
                field(WE2_Position; WE2_Position)
                {
                }
                field(WE2_Duration; WE2_Duration)
                {
                }
                field(WE3_SN; WE3_SN)
                {
                }
                field(WE3_Orgnization; WE3_Orgnization)
                {
                }
                field(WE3_Department; WE3_Department)
                {
                }
                field(WE3_Position; WE3_Position)
                {
                }
                field(WE3_Duration; WE3_Duration)
                {
                }
                field(WE4_SN; WE4_SN)
                {
                }
                field(WE4_Orgnization; WE4_Orgnization)
                {
                }
                field(WE4_Department; WE4_Department)
                {
                }
                field(WE4_Position; WE4_Position)
                {
                }
                field(WE4_Duration; WE4_Duration)
                {
                }
                field(WE5_SN; WE5_SN)
                {
                }
                field(WE5_Orgnization; WE5_Orgnization)
                {
                }
                field(WE5_Department; WE5_Department)
                {
                }
                field(WE5_Position; WE5_Position)
                {
                }
                field(WE5_Duration; WE5_Duration)
                {
                }
                field(Ref1_SN; Ref1_SN)
                {
                }
                field(Ref1_FullName; Ref1_FullName)
                {
                }
                field(Ref1_Relationship; Ref1_Relationship)
                {
                }
                field(Ref1_Company; Ref1_Company)
                {
                }
                field(Ref1_Phone; Ref1_Phone)
                {
                }
                field(Ref1_Address; Ref1_Address)
                {
                }
                field(Ref2_SN; Ref2_SN)
                {
                }
                field(Ref2_FullName; Ref2_FullName)
                {
                }
                field(Ref2_Relationship; Ref2_Relationship)
                {
                }
                field(Ref2_Company; Ref2_Company)
                {
                }
                field(Ref2_Phone; Ref2_Phone)
                {
                }
                field(Ref2_Address; Ref2_Address)
                {
                }
                field(Language; Language)
                {
                }
                field("Computer Knowledge"; "Computer Knowledge")
                {
                }
                field("Driving License"; "Driving License")
                {
                }
                field(Vehicle; Vehicle)
                {
                }
                field(Awards; Awards)
                {
                }
                field("Expected Salary"; "Expected Salary")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000014>")
            {
                Caption = 'Function';
                action("Import Applicant Data")
                {
                    Caption = 'Import Applicant Data';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CurrFile: File;
                        CurrStream: InStream;
                        ClientFileName: Text[1024];
                        SelectCSVFile: Label 'Select the CSV Requisition File.';
                    begin
                        BEGIN
                            IF ISSERVICETIER THEN BEGIN
                                IF NOT UPLOADINTOSTREAM(
                                                  SelectCSVFile,
                                                   'C:\',
                                                   'XML File *.csv| *.csv',
                                                    ClientFileName,
                                                    CurrStream) THEN
                                    EXIT;
                            END
                            ELSE BEGIN
                                CurrFile.OPEN('C:\');
                                CurrFile.CREATEINSTREAM(CurrStream);
                            END;
                            XMLPORT.IMPORT(50012, CurrStream);
                            IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        SETRANGE(ShortList, FALSE);
        //SETRANGE(Reject,FALSE);
        //SETRANGE(Interview,FALSE);
        SETRANGE("Written Exam", FALSE);
        FILTERGROUP(0);
    end;
}

