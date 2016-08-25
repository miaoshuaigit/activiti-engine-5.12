create table ACT_HI_PROCINST (
    ID_ NVARCHAR2(64) not null,
    PROC_INST_ID_ NVARCHAR2(64) not null,
    BUSINESS_KEY_ NVARCHAR2(255),
    PROC_DEF_ID_ NVARCHAR2(64) not null,
    START_TIME_ TIMESTAMP(6) not null,
    END_TIME_ TIMESTAMP(6),
    DURATION_ NUMBER(19,0),
    START_USER_ID_ NVARCHAR2(255),
    START_ACT_ID_ NVARCHAR2(255),
    END_ACT_ID_ NVARCHAR2(255),
    SUPER_PROCESS_INSTANCE_ID_ NVARCHAR2(64),
    DELETE_REASON_ NVARCHAR2(2000),
    primary key (ID_),
    unique (PROC_INST_ID_)
);

create table ACT_HI_ACTINST (
    ID_ NVARCHAR2(64) not null,
    PROC_DEF_ID_ NVARCHAR2(64) not null,
    PROC_INST_ID_ NVARCHAR2(64) not null,
    EXECUTION_ID_ NVARCHAR2(64) not null,
    ACT_ID_ NVARCHAR2(255) not null,
    TASK_ID_ NVARCHAR2(64),
    CALL_PROC_INST_ID_ NVARCHAR2(64),
    ACT_NAME_ NVARCHAR2(255),
    ACT_TYPE_ NVARCHAR2(255) not null,
    ASSIGNEE_ NVARCHAR2(64),
    START_TIME_ TIMESTAMP(6) not null,
    END_TIME_ TIMESTAMP(6),
    DURATION_ NUMBER(19,0),    
    START_TIME_LONG NUMBER(19),
    END_TIME_LONG  NUMBER(19),
    primary key (ID_)
);

create table ACT_HI_TASKINST (
    ID_ NVARCHAR2(64) not null,
    PROC_DEF_ID_ NVARCHAR2(64),
    TASK_DEF_KEY_ NVARCHAR2(255),
    PROC_INST_ID_ NVARCHAR2(64),
    EXECUTION_ID_ NVARCHAR2(64),
    PARENT_TASK_ID_ NVARCHAR2(64),
    NAME_ NVARCHAR2(255),
    DESCRIPTION_ NVARCHAR2(2000),
    OWNER_ NVARCHAR2(255),
    ASSIGNEE_ NVARCHAR2(255),
    START_TIME_ TIMESTAMP(6) not null,
    CLAIM_TIME_ TIMESTAMP(6),
    END_TIME_ TIMESTAMP(6),
    DURATION_ NUMBER(19,0),
    DELETE_REASON_ NVARCHAR2(2000),
    PRIORITY_ INTEGER,
    DUE_DATE_ TIMESTAMP(6),
    FORM_KEY_ NVARCHAR2(255),   
    START_TIME_LONG NUMBER(19),
    END_TIME_LONG  NUMBER(19),
    primary key (ID_)
);

create table ACT_HI_VARINST (
    ID_ NVARCHAR2(64) not null,
    PROC_INST_ID_ NVARCHAR2(64),
    EXECUTION_ID_ NVARCHAR2(64),
    TASK_ID_ NVARCHAR2(64),
    NAME_ NVARCHAR2(255) not null,
    VAR_TYPE_ NVARCHAR2(100),
    REV_ INTEGER,
    BYTEARRAY_ID_ NVARCHAR2(64),
    DOUBLE_ NUMBER(10),
    LONG_ NUMBER(19,0),
    TEXT_ NVARCHAR2(2000),
    TEXT2_ NVARCHAR2(2000),
    primary key (ID_)
);

create table ACT_HI_DETAIL (
    ID_ NVARCHAR2(64) not null,
    TYPE_ NVARCHAR2(255) not null,
    PROC_INST_ID_ NVARCHAR2(64),
    EXECUTION_ID_ NVARCHAR2(64),
    TASK_ID_ NVARCHAR2(64),
    ACT_INST_ID_ NVARCHAR2(64),
    NAME_ NVARCHAR2(255) not null,
    VAR_TYPE_ NVARCHAR2(64),
    REV_ INTEGER,
    TIME_ TIMESTAMP(6) not null,
    BYTEARRAY_ID_ NVARCHAR2(64),
    DOUBLE_ NUMBER(*,10),
    LONG_ NUMBER(19,0),
    TEXT_ NVARCHAR2(2000),
    TEXT2_ NVARCHAR2(2000),
    primary key (ID_)
);

create table ACT_HI_COMMENT (
    ID_ NVARCHAR2(64) not null,
    TYPE_ NVARCHAR2(255),
    TIME_ TIMESTAMP(6) not null,
    USER_ID_ NVARCHAR2(255),
    TASK_ID_ NVARCHAR2(64),
    PROC_INST_ID_ NVARCHAR2(64),
    ACTION_ NVARCHAR2(255),
    MESSAGE_ NVARCHAR2(2000),
    FULL_MSG_ BLOB,
    primary key (ID_)
);

create table ACT_HI_ATTACHMENT (
    ID_ NVARCHAR2(64) not null,
    REV_ INTEGER,
    USER_ID_ NVARCHAR2(255),
    NAME_ NVARCHAR2(255),
    DESCRIPTION_ NVARCHAR2(2000),
    TYPE_ NVARCHAR2(255),
    TASK_ID_ NVARCHAR2(64),
    PROC_INST_ID_ NVARCHAR2(64),
    URL_ NVARCHAR2(2000),
    CONTENT_ID_ NVARCHAR2(64),
    primary key (ID_)
);

create index ACT_IDX_HI_PRO_INST_END on ACT_HI_PROCINST(END_TIME_);
create index ACT_IDX_HI_PRO_I_BUSKEY on ACT_HI_PROCINST(BUSINESS_KEY_);
create index ACT_IDX_HI_ACT_INST_START on ACT_HI_ACTINST(START_TIME_);
create index ACT_IDX_HI_ACT_INST_END on ACT_HI_ACTINST(END_TIME_);
create index ACT_IDX_HI_DETAIL_PROC_INST on ACT_HI_DETAIL(PROC_INST_ID_);
create index ACT_IDX_HI_DETAIL_ACT_INST on ACT_HI_DETAIL(ACT_INST_ID_);
create index ACT_IDX_HI_DETAIL_TIME on ACT_HI_DETAIL(TIME_);
create index ACT_IDX_HI_DETAIL_NAME on ACT_HI_DETAIL(NAME_);
create index ACT_IDX_HI_DETAIL_TASK_ID on ACT_HI_DETAIL(TASK_ID_);
create index ACT_IDX_HI_PROCVAR_PROC_INST on ACT_HI_VARINST(PROC_INST_ID_);
create index ACT_IDX_HI_PROCVAR_NAME_TYPE on ACT_HI_VARINST(NAME_, VAR_TYPE_);

-- see http://stackoverflow.com/questions/675398/how-can-i-constrain-multiple-columns-to-prevent-duplicates-but-ignore-null-value
create unique index ACT_UNIQ_HI_BUS_KEY on ACT_HI_PROCINST
   (case when BUSINESS_KEY_ is null then null else PROC_DEF_ID_ end,
    case when BUSINESS_KEY_ is null then null else BUSINESS_KEY_ end);

create index ACT_IDX_HI_ACT_INST_PROCINST on ACT_HI_ACTINST(PROC_INST_ID_, ACT_ID_);
create index ACT_IDX_HI_ACT_INST_EXEC on ACT_HI_ACTINST(EXECUTION_ID_, ACT_ID_);

--流程引擎扩展表字段
ALTER TABLE ACT_RU_TASK
ADD (DURATION_NODE NUMBER(19));



ALTER TABLE ACT_RU_TASK
ADD (ADVANCESEND NUMBER(1) DEFAULT 0);



ALTER TABLE ACT_RU_TASK
ADD (OVERTIMESEND NUMBER(1));



ALTER TABLE ACT_RU_TASK
MODIFY(DURATION_NODE  DEFAULT 0);

ALTER TABLE ACT_RU_TASK
MODIFY(OVERTIMESEND  DEFAULT 0);

ALTER TABLE ACT_RU_TASK
ADD (ALERTTIME TIMESTAMP(7));



ALTER TABLE ACT_RU_TASK
ADD (OVERTIME TIMESTAMP(7));




ALTER TABLE ACT_HI_ACTINST
ADD (DURATION_NODE NUMBER(19));



ALTER TABLE ACT_HI_ACTINST
ADD (ADVANCESEND NUMBER(1) DEFAULT 0);




ALTER TABLE ACT_HI_ACTINST
ADD (OVERTIMESEND NUMBER(1));


ALTER TABLE ACT_HI_ACTINST
MODIFY(DURATION_NODE  DEFAULT 0);

ALTER TABLE ACT_HI_ACTINST
MODIFY(OVERTIMESEND  DEFAULT 0);

ALTER TABLE ACT_HI_ACTINST
ADD (ALERTTIME TIMESTAMP(7));



ALTER TABLE ACT_HI_ACTINST
ADD (OVERTIME TIMESTAMP(7));



----------------------------------------------------
ALTER TABLE ACT_HI_TASKINST
ADD (DURATION_NODE NUMBER(19));


ALTER TABLE ACT_HI_TASKINST
ADD (ADVANCESEND NUMBER(1) DEFAULT 0);




ALTER TABLE ACT_HI_TASKINST
ADD (OVERTIMESEND NUMBER(1));


ALTER TABLE ACT_HI_TASKINST
MODIFY(DURATION_NODE  DEFAULT 0);

ALTER TABLE ACT_HI_TASKINST
MODIFY(OVERTIMESEND  DEFAULT 0);

ALTER TABLE ACT_HI_TASKINST
ADD (ALERTTIME TIMESTAMP(7));



ALTER TABLE ACT_HI_TASKINST
ADD (OVERTIME TIMESTAMP(7));


---------------------
ALTER TABLE ACT_HI_ACTINST
ADD (NOTICERATE NUMBER(8));



ALTER TABLE ACT_HI_TASKINST
ADD (NOTICERATE NUMBER(8));



ALTER TABLE ACT_RU_TASK
ADD (NOTICERATE NUMBER(8));


-------------------------

ALTER TABLE ACT_HI_ACTINST
ADD (IS_CONTAIN_HOLIDAY NUMBER(1));



ALTER TABLE ACT_HI_TASKINST
ADD (IS_CONTAIN_HOLIDAY NUMBER(1));



ALTER TABLE ACT_RU_TASK
ADD (IS_CONTAIN_HOLIDAY NUMBER(1) );

-- Create table
create table td_wf_rejectlog
(
  newtaskid    nvarchar2(64),
  rejecttaskid nvarchar2(64),
  rejectnode   nvarchar2(100)
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table td_wf_rejectlog
  add constraint rejectlog_pk primary key (NEWTASKID);

ALTER TABLE ACT_HI_ACTINST
 ADD (IS_AUTO_COMPLETE  NUMBER(1)                   DEFAULT 0);

ALTER TABLE ACT_HI_ACTINST
 ADD (AUTO_HANDLER  NVARCHAR2(255));

ALTER TABLE ACT_HI_TASKINST
 ADD (BUSSINESS_OP  NVARCHAR2(255));

ALTER TABLE ACT_HI_TASKINST
 ADD (BUSSINESS_REMARK  NVARCHAR2(2000));
 
 ALTER TABLE ACT_HI_ACTINST

 ADD (BUSSINESS_OP  NVARCHAR2(255));

ALTER TABLE ACT_HI_ACTINST

 ADD (BUSSINESS_REMARK  NVARCHAR2(2000));
 ALTER TABLE ACT_HI_ACTINST

 ADD (DELETE_REASON_  NVARCHAR2(2000)); 
 
 ALTER TABLE ACT_HI_ACTINST
 ADD (OWNER_  NVARCHAR2(255)); 
 
  ALTER TABLE ACT_HI_ACTINST
 ADD (CLAIM_TIME_  TIMESTAMP(6)); 
 
    ALTER TABLE td_wf_rejectlog
 ADD   (optype  NUMBER(1)   DEFAULT 0); 
ALTER TABLE TD_WF_REJECTLOG
 ADD (PROCESS_ID  NVARCHAR2(100));
 -- Create table
create table td_wf_hi_rejectlog
(
  newtaskid    nvarchar2(64),
  rejecttaskid nvarchar2(64),
  rejectnode   nvarchar2(100),
   BACKUPTIME  TIMESTAMP(6), 
  optype  NUMBER(1)  DEFAULT 0,
  PROCESS_ID  NVARCHAR2(100)
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table td_wf_hi_rejectlog
  add constraint hi_rejectlog_pk primary key (NEWTASKID);


-----------------------------------------------------------------------------
-- TD_WF_COPYTASK
-----------------------------------------------------------------------------

CREATE TABLE TD_WF_COPYTASK
(
    ID VARCHAR2(100) NOT NULL,
    COPERTYPE NUMBER(1) default 0,
    COPER VARCHAR2(255),
    PROCESS_ID NVARCHAR2(100),
    PROCESS_KEY NVARCHAR2(200),
    BUSINESSKEY NVARCHAR2(255),
    COPYTIME TIMESTAMP,
    ACT_ID NVARCHAR2(64),
    ACT_NAME NVARCHAR2(255),
    ACT_INSTID NVARCHAR2(64),
     TASKTYPE NUMBER(1) default 1
);

ALTER TABLE TD_WF_COPYTASK
    ADD CONSTRAINT TD_WF_COPYTASK_PK
PRIMARY KEY (ID);






-----------------------------------------------------------------------------
-- TD_WF_HI_COPYTASK
-----------------------------------------------------------------------------

CREATE TABLE TD_WF_HI_COPYTASK
(
    ID VARCHAR2(100) NOT NULL,
    copyid VARCHAR2(100),
    COPORG VARCHAR2(255),
    COPER VARCHAR2(255),
    PROCESS_ID NVARCHAR2(100),
    PROCESS_KEY NVARCHAR2(200),
    BUSINESSKEY NVARCHAR2(255),
    COPYTIME TIMESTAMP,
    READTIME TIMESTAMP,
    ACT_ID NVARCHAR2(64),
    ACT_NAME NVARCHAR2(255),
    ACT_INSTID NVARCHAR2(64),
    COPERCNNAME NVARCHAR2(255),
     TASKTYPE NUMBER(1) default 1
);

ALTER TABLE TD_WF_HI_COPYTASK
    ADD CONSTRAINT TD_WF_HI_COPYTASK_PK
PRIMARY KEY (ID);
create index IDX_HI_COPYTASK on TD_WF_HI_COPYTASK(ACT_INSTID);    
create index IDX_COPYTASK on TD_WF_COPYTASK(COPER,COPERTYPE);  
create index IDX_HI_COPYTASK_BKEY on TD_WF_HI_COPYTASK(BUSINESSKEY);    
create index IDX_COPYTASK_BKEY on TD_WF_COPYTASK(BUSINESSKEY);  
create index IDX_HI_COPYTASK_PKEY on TD_WF_HI_COPYTASK(PROCESS_KEY);    
create index IDX_COPYTASK_PKEY on TD_WF_COPYTASK(PROCESS_KEY);   