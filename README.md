
Create a new repository on the command line

touch README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/yin-bp/activiti-engine-5.12.git
git push -u origin master

Push an existing repository from the command line

git remote add origin https://github.com/yin-bp/activiti-engine-5.12.git
git push -u origin master

自由流改造分析：
org.activiti.engine.impl.TaskServiceImpl
    complete(String taskId,String destinationTaskKey) 
       --call->org.activiti.engine.impl.interceptor.CommandContextInterceptor
                                                                  public <T> T execute(Command<T> command)
                      execute(new CompleteTaskCmd(taskId, null,destinationTaskKey));

org.activiti.engine.impl.cmd.CompleteTaskCmd
	protected Void execute(CommandContext commandContext, TaskEntity task)                      
创建任务(关联Assignment)：
org.activiti.engine.impl.bpmn.behavior.UserTaskActivityBehavior        
 public void execute(ActivityExecution execution) throws Exception {
    TaskEntity task = TaskEntity.createAndInsert(execution);  
    handleAssignments(task, execution);
 protected void handleAssignments(TaskEntity task, ActivityExecution execution)   
    
建立用户和任务关系Canidate
org.activiti.engine.impl.persistence.entity.ExecutionEntity
 public IdentityLinkEntity addIdentityLink(String userId, String type) {
    IdentityLinkEntity identityLinkEntity = IdentityLinkEntity.createAndInsert();
                
任务分配相关：
org.activiti.engine.impl.bpmn.behavior.BpmnActivityBehavior
	 protected void performOutgoingBehavior(ActivityExecution execution, 
          boolean checkConditions, boolean throwExceptionIfExecutionStuck, List<ActivityExecution> reusableExecutions)  
        选择路径  

org.activiti.engine.impl.pvm.runtime.AtomicOperationTransitionDestroyScope
		 public void execute(InterpretableExecution execution)

org.activiti.engine.impl.pvm.runtime.AtomicOperationTransitionNotifyListenerTake
	public void execute(InterpretableExecution execution)		
	
	
驳回改造：                      
会签
 org.activiti.engine.impl.bpmn.behavior.ParallelMultiInstanceBehavior(并行 )
 
单实例任务：
org.activiti.engine.impl.bpmn.behavior.BpmnActivityBehavior 
单实例任务驳回时，需要判断任务对应的流程实例中还有别的任务在运行，如果有，则需要检测驳回到 的节点是不是这些其他任务的直接或者
间接前置节点，如果是则不允许驳回，如果不是则允许驳回。

并行gateway                      
 org.activiti.engine.impl.bpmn.behavior.ParallelGatewayActivityBehavior
 org.activiti.engine.impl.bpmn.behavior.InclusiveGatewayActivityBehavior	
 
获取任务可以跳转节点列表
自动驳回到上一个处理环节
配置流程处理环节
会签串并行改造  
	如果下流程中存在多实例任务，那么可以通过流程变量在运行时或者在发起流程的时候设置相关多实例任务执行的方式为串行还是并行
   * 变量的命名规范为：
   * taskkey.bpmn.behavior.multiInstance.mode
   * 取值范围为：
   * 	parallel
   * 	sequential
   * 说明：taskkey为对应的任务的定义id
   * 
   * 这个变量可以在设计流程时统一配置，可以启动流程实例时动态修改，也可以在上个活动任务完成时修改
增加UserInfoMap组件，用来在流程引擎中获取用户相关属性（根据userAccount或者根据用户ID获取用户属性）