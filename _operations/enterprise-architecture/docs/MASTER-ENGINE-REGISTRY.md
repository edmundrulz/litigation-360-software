# MASTER ENGINE REGISTRY

Generated: 2026-06-19T06:02:48.093Z

Total Engines: 35

- alertManager â€” backend/src/automation/alertManager.js â€” dependencies: none
- autonomousOperationsEngine â€” backend/src/automation/autonomousOperationsEngine.js â€” dependencies: executiveCommandCentre, predictiveAnalyticsEngine, legalOperationsAssistant, notificationService, workflowEngine, courtOperationsEngine, documentLifecycleEngine, matterIntelligenceEngine
- backupRecoveryEngine â€” backend/src/automation/backupRecoveryEngine.js â€” dependencies: enterpriseHardeningEngine
- courtNavigationEngine â€” backend/src/automation/courtNavigationEngine.js â€” dependencies: courtOperationsEngine, documentLifecycleEngine, workflowEngine, notificationService
- courtOperationsEngine â€” backend/src/automation/courtOperationsEngine.js â€” dependencies: eventBus, notificationService, workflowEngine
- deploymentReadinessCentre â€” backend/src/automation/deploymentReadinessCentre.js â€” dependencies: none
- documentLifecycleEngine â€” backend/src/automation/documentLifecycleEngine.js â€” dependencies: eventBus, notificationService, workflowEngine
- enterpriseGovernanceEngine â€” backend/src/automation/enterpriseGovernanceEngine.js â€” dependencies: notificationService, workflowEngine, matterIntelligenceEngine, autonomousOperationsEngine
- enterpriseHardeningEngine â€” backend/src/automation/enterpriseHardeningEngine.js â€” dependencies: none
- enterpriseMonitoringEngine â€” backend/src/automation/enterpriseMonitoringEngine.js â€” dependencies: metricsCollector, alertManager
- environmentValidationEngine â€” backend/src/automation/environmentValidationEngine.js â€” dependencies: none
- eventBus â€” backend/src/automation/eventBus.js â€” dependencies: handlerRegistry
- eventTypes â€” backend/src/automation/eventTypes.js â€” dependencies: none
- executiveCommandCentre â€” backend/src/automation/executiveCommandCentre.js â€” dependencies: handlerRegistry, eventBus, notificationService, workflowEngine, documentLifecycleEngine, courtOperationsEngine, matterIntelligenceEngine
- handlerRegistry â€” backend/src/automation/handlerRegistry.js â€” dependencies: eventTypes, handlers/clientCreated, handlers/matterCreated, handlers/documentUploaded, handlers/taskCompleted, handlers/courtDateAdded, handlers/deadlineCreated, handlers/paymentReceived, handlers/invoiceCreated, handlers/userCreated, handlers/roleChanged
- clientCreated â€” backend/src/automation/handlers/clientCreated.js â€” dependencies: none
- courtDateAdded â€” backend/src/automation/handlers/courtDateAdded.js â€” dependencies: none
- deadlineCreated â€” backend/src/automation/handlers/deadlineCreated.js â€” dependencies: none
- documentUploaded â€” backend/src/automation/handlers/documentUploaded.js â€” dependencies: none
- invoiceCreated â€” backend/src/automation/handlers/invoiceCreated.js â€” dependencies: none
- matterCreated â€” backend/src/automation/handlers/matterCreated.js â€” dependencies: none
- paymentReceived â€” backend/src/automation/handlers/paymentReceived.js â€” dependencies: none
- roleChanged â€” backend/src/automation/handlers/roleChanged.js â€” dependencies: none
- taskCompleted â€” backend/src/automation/handlers/taskCompleted.js â€” dependencies: none
- userCreated â€” backend/src/automation/handlers/userCreated.js â€” dependencies: none
- legalOperationsAssistant â€” backend/src/automation/legalOperationsAssistant.js â€” dependencies: executiveCommandCentre, matterIntelligenceEngine, notificationService
- loadTestingEngine â€” backend/src/automation/loadTestingEngine.js â€” dependencies: enterpriseMonitoringEngine, enterpriseHardeningEngine, backupRecoveryEngine
- mapsIntegrationLayer â€” backend/src/automation/mapsIntegrationLayer.js â€” dependencies: courtNavigationEngine, courtOperationsEngine
- matterIntelligenceEngine â€” backend/src/automation/matterIntelligenceEngine.js â€” dependencies: notificationService, documentLifecycleEngine, courtOperationsEngine, workflowEngine
- metricsCollector â€” backend/src/automation/metricsCollector.js â€” dependencies: none
- notificationService â€” backend/src/automation/notificationService.js â€” dependencies: none
- performanceOptimizationEngine â€” backend/src/automation/performanceOptimizationEngine.js â€” dependencies: enterpriseMonitoringEngine, enterpriseHardeningEngine, backupRecoveryEngine
- predictiveAnalyticsEngine â€” backend/src/automation/predictiveAnalyticsEngine.js â€” dependencies: executiveCommandCentre, matterIntelligenceEngine, courtOperationsEngine, workflowEngine, documentLifecycleEngine, notificationService
- releaseValidatorEngine â€” backend/src/automation/releaseValidatorEngine.js â€” dependencies: deploymentReadinessCentre, environmentValidationEngine, enterpriseHardeningEngine, backupRecoveryEngine, enterpriseMonitoringEngine, performanceOptimizationEngine
- workflowEngine â€” backend/src/automation/workflowEngine.js â€” dependencies: eventBus, notificationService