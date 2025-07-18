#Область СлужебныеПроцедурыИФункции

Функция ТаблицаПолейДанныйДляРасшифровкиОшибок() Экспорт
	
	ТаблицаДанных        = РаботаСXMLИС.ПустаяТаблицаПредставленийПолей();
	ПараметрыОптимизации = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
	
	Для Каждого ВерсияAPI Из ПараметрыОптимизации.ПоддерживаемыеВерсииAPI Цикл
	
		ПространствоИменСправочники = ИнтеграцияЗЕРНОСлужебный.ПространствоИменПоИмениПакетаXDTO("zerno_api_dictionaries", ПараметрыОптимизации, ВерсияAPI);
		ПространствоИменОрганизации = ИнтеграцияЗЕРНОСлужебный.ПространствоИменПоИмениПакетаXDTO("zerno_organizations",    ПараметрыОптимизации, ВерсияAPI);
		ПространствоИменСДИЗ        = ИнтеграцияЗЕРНОСлужебный.ПространствоИменПоИмениПакетаXDTO("zerno_api_sdiz",         ПараметрыОптимизации, ВерсияAPI);
		ПространствоИменСДИЗППЗ     = ИнтеграцияЗЕРНОСлужебный.ПространствоИменПоИмениПакетаXDTO("zerno_api_gpb_sdiz",     ПараметрыОптимизации, ВерсияAPI);
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменСправочники;
		НоваяСтрока.ЛокальноеИмя     = "Dictionary";
		НоваяСтрока.Представление    = НСтр("ru = 'Название классификатора';
											|en = 'Название классификатора'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменСправочники;
		НоваяСтрока.ЛокальноеИмя     = "MessageID";
		НоваяСтрока.Представление    = НСтр("ru = 'Идентификатор сообщения';
											|en = 'Идентификатор сообщения'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменСправочники;
		НоваяСтрока.ЛокальноеИмя     = "ReferenceMessageID";
		НоваяСтрока.Представление    = НСтр("ru = 'Идентификатор сообщения Назначения';
											|en = 'Идентификатор сообщения Назначения'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменОрганизации;
		НоваяСтрока.ЛокальноеИмя     = "INN";
		НоваяСтрока.Представление    = НСтр("ru = 'ИНН';
											|en = 'ИНН'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменОрганизации;
		НоваяСтрока.ЛокальноеИмя     = "KPP";
		НоваяСтрока.Представление    = НСтр("ru = 'КПП';
											|en = 'КПП'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменОрганизации;
		НоваяСтрока.ЛокальноеИмя     = "RAFP";
		НоваяСтрока.Представление    = НСтр("ru = 'РАФП';
											|en = 'РАФП'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменОрганизации;
		НоваяСтрока.ЛокальноеИмя     = "OGRN";
		НоваяСтрока.Представление    = НСтр("ru = 'ОГРН';
											|en = 'ОГРН'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменОрганизации;
		НоваяСтрока.ЛокальноеИмя     = "Name";
		НоваяСтрока.Представление    = НСтр("ru = 'Наименование';
											|en = 'Наименование'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменОрганизации;
		НоваяСтрока.ЛокальноеИмя     = "FamilyName";
		НоваяСтрока.Представление    = НСтр("ru = 'Фамилия';
											|en = 'Фамилия'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменОрганизации;
		НоваяСтрока.ЛокальноеИмя     = "FirstName";
		НоваяСтрока.Представление    = НСтр("ru = 'Имя';
											|en = 'Имя'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменСДИЗ;
		НоваяСтрока.ЛокальноеИмя     = "sdizNumber";
		НоваяСтрока.Представление    = НСтр("ru = 'Номер СДИЗ';
											|en = 'Номер СДИЗ'");
		НоваяСтрока.Обязательное     = Истина;
		
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ПространствоИмен = ПространствоИменСДИЗППЗ;
		НоваяСтрока.ЛокальноеИмя     = "gpbSdizNumber";
		НоваяСтрока.Представление    = НСтр("ru = 'Номер СДИЗ';
											|en = 'Номер СДИЗ'");
		НоваяСтрока.Обязательное     = Истина;
	
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ШаблонКонвертаSOAP() Экспорт
	
	Возврат
	"<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
	| <soap:Header/>
	| <soap:Body>
	|  <zerno:%ИмяЗапроса% xmlns:zerno=""urn://x-artefacts-mcx-gov-ru/fgiz-zerno/api/ws/types/%ВерсияAPI%"">
	|   <zerno:MessageData Id=""SIGNED_BY_CALLER"">
	|    <zerno:MessageID>%ИдентификаторСообщения%</zerno:MessageID>
	|    <zerno:ReferenceMessageID>%ИдентификаторСвязанногоСообщения%</zerno:ReferenceMessageID>%ТелоСообщения%
	|   </zerno:MessageData>
	|   <zerno:InformationSystemSignature>
	|    <ds:Signature xmlns:ds=""http://www.w3.org/2000/09/xmldsig#"">
	|     <ds:SignedInfo>
	|      <ds:CanonicalizationMethod Algorithm=""http://www.w3.org/2001/10/xml-exc-c14n#""/>
	|      <ds:SignatureMethod Algorithm=""%SignatureMethod%""/>
	|       <ds:Reference URI=""#SIGNED_BY_CALLER"">
	|        <ds:Transforms>
	|         <ds:Transform Algorithm=""http://www.w3.org/2001/10/xml-exc-c14n#""/>
	|         <ds:Transform Algorithm=""urn://smev-gov-ru/xmldsig/transform""/>
	|        </ds:Transforms>
	|        <ds:DigestMethod Algorithm=""%DigestMethod%""/>
	|        <ds:DigestValue>%DigestValue%</ds:DigestValue>
	|       </ds:Reference>
	|      </ds:SignedInfo>
	|      <ds:SignatureValue>%SignatureValue%</ds:SignatureValue>
	|      <ds:KeyInfo>
	|      <ds:X509Data>
	|        <ds:X509Certificate>%BinarySecurityToken%</ds:X509Certificate>
	|      </ds:X509Data>
	|     </ds:KeyInfo>
	|    </ds:Signature>
	|   </zerno:InformationSystemSignature>
	|  </zerno:%ИмяЗапроса%>
	| </soap:Body>
	|</soap:Envelope>";
	
КонецФункции

// Представления настроек оптимизации.
// 
// Возвращаемое значение:
// 	Соответствие - Представление параметров сканирования.
Функция ПредставленияНастроекОптимизации() Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие();
	ВозвращаемоеЗначение.Вставить(
		"КоличествоЗапросовВМинуту",
		НСтр("ru = 'Количество HTTP-запросов в минуту';
			|en = 'Количество HTTP-запросов в минуту'"));
	ВозвращаемоеЗначение.Вставить(
		"ИнтервалМеждуОтправкойЗапросаИПолучениемРезультата",
		НСтр("ru = 'Интервал между HTTP-запросами отправки сведений и получением результата';
			|en = 'Интервал между HTTP-запросами отправки сведений и получением результата'"));
	ВозвращаемоеЗначение.Вставить(
		"ИнтервалМеждуПолучениемРезультатов",
		НСтр("ru = 'Интервал между HTTP-запросами получения результатов';
			|en = 'Интервал между HTTP-запросами получения результатов'"));
	ВозвращаемоеЗначение.Вставить(
		"ТаймаутHTTPЗапросов",
		НСтр("ru = 'Таймаут HTTP-запросов';
			|en = 'Таймаут HTTP-запросов'"));
	ВозвращаемоеЗначение.Вставить(
		"КоличествоЭлементовСтраницыОтвета",
		НСтр("ru = 'Количество элементов на странице';
			|en = 'Количество элементов на странице'"));
	ВозвращаемоеЗначение.Вставить(
		"КоличествоЭлементовСтраницыОтветаСправочника",
		НСтр("ru = 'Количество элементов на странице (справочники)';
			|en = 'Количество элементов на странице (справочники)'"));
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ИспользоватьАвтоматическийОбменДанными(Организация, Подразделение = Неопределено) Экспорт
	
	Возврат ИнтеграцияЗЕРНО.ИспользоватьАвтоматическийОбменДанными(Организация, Подразделение);
	
КонецФункции

Функция ЭтоВерсияВключая_1_0_8(Версия) Экспорт
	Возврат (ИнтеграцияИСКлиентСервер.СравнитьВерсии(Версия, "1.0.8") >= 0);
КонецФункции

#КонецОбласти
