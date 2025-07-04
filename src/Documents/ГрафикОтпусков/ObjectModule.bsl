#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОтпускаСотрудников", Сотрудники.Выгрузить());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОтпускаСотрудниковСотрудники.Сотрудник,
		|	ОтпускаСотрудниковСотрудники.ВидОтпуска,
		|	ОтпускаСотрудниковСотрудники.НомерСтроки,
		|	ОтпускаСотрудниковСотрудники.ДатаНачала,
		|	ОтпускаСотрудниковСотрудники.ДатаОкончания
		|ПОМЕСТИТЬ ВТОтпускаСотрудников
		|ИЗ
		|	&ОтпускаСотрудников КАК ОтпускаСотрудниковСотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтпускаСотрудников.Сотрудник,
		|	ОтпускаСотрудников.НомерСтроки
		|ПОМЕСТИТЬ ВТСтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска
		|ИЗ
		|	ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|ГДЕ
		|	ОтпускаСотрудников.ДатаНачала > ОтпускаСотрудников.ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтпускаСотрудников.Сотрудник,
		|	МАКСИМУМ(ОтпускаСотрудниковДругие.НомерСтроки) КАК НомерСтроки
		|ПОМЕСТИТЬ ВТПересекаютсяПериодыОтпусков
		|ИЗ
		|	ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОтпускаСотрудников КАК ОтпускаСотрудниковДругие
		|		ПО ОтпускаСотрудников.Сотрудник = ОтпускаСотрудниковДругие.Сотрудник
		|			И ОтпускаСотрудников.НомерСтроки <> ОтпускаСотрудниковДругие.НомерСтроки
		|			И ОтпускаСотрудников.ДатаОкончания >= ОтпускаСотрудниковДругие.ДатаНачала
		|			И ОтпускаСотрудников.ДатаОкончания <= ОтпускаСотрудниковДругие.ДатаОкончания
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтпускаСотрудников.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПересекаютсяПериодыОтпусков.Сотрудник,
		|	ПересекаютсяПериодыОтпусков.НомерСтроки КАК НомерСтроки,
		|	ОтпускаСотрудников.ВидОтпуска КАК ВидОтпуска,
		|	ИСТИНА КАК ПересекаютсяПериоды,
		|	ЛОЖЬ КАК НекорректныйПериодПредоставления
		|ПОМЕСТИТЬ ВТСводный
		|ИЗ
		|	ВТПересекаютсяПериодыОтпусков КАК ПересекаютсяПериодыОтпусков
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|		ПО ПересекаютсяПериодыОтпусков.НомерСтроки = ОтпускаСотрудников.НомерСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска.Сотрудник,
		|	СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска.НомерСтроки,
		|	ОтпускаСотрудников.ВидОтпуска,
		|	ЛОЖЬ,
		|	ИСТИНА
		|ИЗ
		|	ВТСтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска КАК СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|		ПО СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска.НомерСтроки = ОтпускаСотрудников.НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сводный.Сотрудник,
		|	Сводный.НомерСтроки КАК НомерСтроки,
		|	Сводный.ВидОтпуска,
		|	МАКСИМУМ(Сводный.ПересекаютсяПериоды) КАК ПересекаютсяПериоды,
		|	МАКСИМУМ(Сводный.НекорректныйПериодПредоставления) КАК НекорректныйПериодПредоставления
		|ИЗ
		|	ВТСводный КАК Сводный
		|
		|СГРУППИРОВАТЬ ПО
		|	Сводный.Сотрудник,
		|	Сводный.НомерСтроки,
		|	Сводный.ВидОтпуска
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ТекстСообщения = "";
			
			Если Выборка.НекорректныйПериодПредоставления Тогда
				ТекстСообщения = ?(ПустаяСтрока(ТекстСообщения), "", ТекстСообщения +", ")
					+ НСтр("ru = 'некорректно задан период предоставления отпуска';
							|en = 'leave period is invalid'");
			КонецЕсли; 
			
			Если Выборка.ПересекаютсяПериоды Тогда
				ТекстСообщения = ?(ПустаяСтрока(ТекстСообщения), "", ТекстСообщения +", ")
					+ НСтр("ru = 'пересекается период нахождения в отпуске';
							|en = 'leave periods overlap'");
			КонецЕсли; 
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По сотруднику %1:';
					|en = 'By employee %1:'"),
				Выборка.Сотрудник)
				+ " " + ТекстСообщения;
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				,
				"Сотрудники[" + (Выборка.НомерСтроки - 1) + "].Сотрудник",
				"Объект",
				Отказ);
			
		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ОтменитьЗапланированныеОтпуска();
	ЗарегистрироватьЗапланированныеОтпуска();
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ОтменитьЗапланированныеОтпуска();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСобытия = Дата;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Действие") 
		И ДанныеЗаполнения.Действие = "ЗаполнитьПоСборуГрафиковОтпусков" Тогда 
		ЗаполнитьПоСборуГрафиковОтпусков(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтменитьЗапланированныеОтпуска()

	Запрос = Новый Запрос;

	Запрос.Текст = "ВЫБРАТЬ
	               |	ПлановыеЕжегодныеОтпуска.Сотрудник КАК Сотрудник,
	               |	ПлановыеЕжегодныеОтпуска.ДатаНачала КАК ДатаНачала
	               |ИЗ
	               |	РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
	               |ГДЕ
	               |	ПлановыеЕжегодныеОтпуска.ДокументПланирования = &ДокументПланирования";
	
	Запрос.УстановитьПараметр("ДокументПланирования", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ПлановыеЕжегодныеОтпуска.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
		НаборЗаписей.Отбор.ДатаНачала.Установить(Выборка.ДатаНачала);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗарегистрироватьЗапланированныеОтпуска()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ГрафикОтпусковСотрудники.Ссылка КАК Ссылка,
	               |	ГрафикОтпусковСотрудники.НомерСтроки КАК НомерСтроки,
	               |	ГрафикОтпусковСотрудники.Сотрудник КАК Сотрудник,
	               |	ГрафикОтпусковСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ГрафикОтпусковСотрудники.ВидОтпуска КАК ВидОтпуска,
	               |	ГрафикОтпусковСотрудники.ДатаНачала КАК ДатаНачала,
	               |	ГрафикОтпусковСотрудники.ДатаОкончания КАК ДатаОкончания,
	               |	ГрафикОтпусковСотрудники.КоличествоДней КАК КоличествоДней,
	               |	ГрафикОтпусковСотрудники.Примечание КАК Примечание
	               |ПОМЕСТИТЬ ВТСотрудники
	               |ИЗ
	               |	Документ.ГрафикОтпусков.Сотрудники КАК ГрафикОтпусковСотрудники
	               |ГДЕ
	               |	ГрафикОтпусковСотрудники.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПереносОтпуска.Сотрудник КАК Сотрудник,
	               |	ПереносОтпуска.ИсходнаяДатаНачала КАК ДатаНачала,
	               |	МАКСИМУМ(ПереносОтпуска.Ссылка) КАК ДокументПереноса
	               |ПОМЕСТИТЬ ВТДокументыПереноса
	               |ИЗ
	               |	ВТСотрудники КАК Сотрудники
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПереносОтпуска КАК ПереносОтпуска
	               |		ПО Сотрудники.Сотрудник = ПереносОтпуска.Сотрудник
	               |			И Сотрудники.ДатаНачала = ПереносОтпуска.ИсходнаяДатаНачала
	               |			И (ПереносОтпуска.Проведен)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПереносОтпуска.Сотрудник,
	               |	ПереносОтпуска.ИсходнаяДатаНачала
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДокументыПереноса.Сотрудник КАК Сотрудник,
	               |	ДокументыПереноса.ДатаНачала КАК ДатаНачала,
	               |	ДокументыПереноса.ДокументПереноса КАК ДокументПереноса,
	               |	ПереносОтпускаПереносы.ДатаНачала КАК ПеренесеннаяДатаНачала,
	               |	ПереносОтпускаПереносы.ДатаОкончания КАК ПеренесеннаяДатаОкончания,
	               |	ПереносОтпускаПереносы.КоличествоДней КАК ПеренесенноеКоличествоДней
	               |ПОМЕСТИТЬ ВТПереносыОтпусков
	               |ИЗ
	               |	ВТДокументыПереноса КАК ДокументыПереноса
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПереносОтпуска.Переносы КАК ПереносОтпускаПереносы
	               |		ПО ДокументыПереноса.ДокументПереноса = ПереносОтпускаПереносы.Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Сотрудники.НомерСтроки КАК НомерСтроки,
	               |	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	Сотрудники.Сотрудник КАК Сотрудник,
	               |	Сотрудники.ДатаНачала КАК ДатаНачала,
	               |	ПереносыОтпусков.ПеренесеннаяДатаНачала КАК ПеренесеннаяДатаНачала,
	               |	Сотрудники.Ссылка КАК ДокументПланирования,
	               |	Сотрудники.КоличествоДней КАК КоличествоДней,
	               |	Сотрудники.ВидОтпуска КАК ВидОтпуска,
	               |	Сотрудники.ДатаОкончания КАК ДатаОкончания,
	               |	ПереносыОтпусков.ДокументПереноса КАК ДокументПереноса,
	               |	ПереносыОтпусков.ПеренесеннаяДатаОкончания КАК ПеренесеннаяДатаОкончания,
	               |	ПереносыОтпусков.ПеренесенноеКоличествоДней КАК ПеренесенноеКоличествоДней,
	               |	Сотрудники.Примечание КАК Примечание
	               |ИЗ
	               |	ВТСотрудники КАК Сотрудники
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТПереносыОтпусков КАК ПереносыОтпусков
	               |		ПО Сотрудники.Сотрудник = ПереносыОтпусков.Сотрудник
	               |			И Сотрудники.ДатаНачала = ПереносыОтпусков.ДатаНачала";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ПлановыеЕжегодныеОтпуска.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
		НаборЗаписей.Отбор.ДатаНачала.Установить(Выборка.ДатаНачала);
		НаборЗаписей.Отбор.ПеренесеннаяДатаНачала.Установить(Выборка.ПеренесеннаяДатаНачала);
		
		НоваяСтрока = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.Запланирован = Истина;
		НоваяСтрока.Перенесен = ЗначениеЗаполнено(НоваяСтрока.ДокументПереноса);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;	

КонецПроцедуры

Процедура ЗаполнитьПоСборуГрафиковОтпусков(ДанныеЗаполнения)
	
	Организация = ДанныеЗаполнения.Организация;
	СборГрафиковОтпусков = ДанныеЗаполнения.СборГрафиковОтпусков;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("КорневойСборГрафиков", ДанныеЗаполнения.СборГрафиковОтпусков);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	СборГрафиковОтпусковСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СборГрафиковОтпусковСотрудники.ДатаНачала КАК ДатаНачала,
		|	СборГрафиковОтпусковСотрудники.ДатаОкончания КАК ДатаОкончания
		|ПОМЕСТИТЬ ВТПериодыОтпусков
		|ИЗ
		|	Документ.СборГрафиковОтпусков.Сотрудники КАК СборГрафиковОтпусковСотрудники
		|ГДЕ
		|	СборГрафиковОтпусковСотрудники.Ссылка.КорневойСборГрафиков = &КорневойСборГрафиков
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПериодыОтпусков.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	ВТПериодыОтпусков КАК ПериодыОтпусков";
	
	ФизическиеЛица = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
	ПараметрыПолучения = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолучения.СписокФизическихЛиц = ФизическиеЛица;
	ПараметрыПолучения.Организация = ДанныеЗаполнения.Организация;
	ДанныеСотрудников = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолучения);
	
	Запрос.УстановитьПараметр("Сотрудники", ДанныеСотрудников.ВыгрузитьКолонку("Сотрудник"));
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Сотрудник,
		|	ПериодыОтпусков.ДатаНачала КАК Начало,
		|	ПериодыОтпусков.ДатаОкончания КАК Окончание
		|ИЗ
		|	ВТПериодыОтпусков КАК ПериодыОтпусков
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ПериодыОтпусков.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
		|			И (Сотрудники.Ссылка В (&Сотрудники))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	Начало";
	
	ОбщиеПериоды = Запрос.Выполнить().Выгрузить();
	
	Документы.ГрафикОтпусков.ОбработатьОбщиеПериодыОтпусков(ОбщиеПериоды, Сотрудники);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли