#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбновитьГруппуБлокировкиИзмененияОбъекта(УправляемаяФорма, ОбновитьПараметрыБлокировкиИзмененияОбъекта = Ложь, РазрешитьИзменениеОбъекта = Неопределено) Экспорт
	
	Если Не ФормаПроинициализирована(УправляемаяФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбновитьПараметрыБлокировкиИзмененияОбъекта Тогда
		
		УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта = Новый ФиксированныйМассив(
			БлокировкаИзмененияОбъектовВызовСервера.ПараметрыБлокировкиИзмененияОбъекта(УправляемаяФорма.Объект.Ссылка));
		
	КонецЕсли;
	
	Если РазрешитьИзменениеОбъекта = Неопределено Тогда
		
		БлокироватьФорму = Ложь;
		Если УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта = Неопределено
			Или УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта.Количество() = 0 Тогда
			
			БлокировкаИзмененияОбъектовГруппаВидимость = Ложь;
		Иначе
			БлокировкаИзмененияОбъектовГруппаВидимость = Истина;
			Для Каждого ПараметрБлокировки Из УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта Цикл
				Если ПараметрБлокировки.УстановитьБлокировку Тогда
					БлокироватьФорму = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли РазрешитьИзменениеОбъекта = Истина Тогда
		БлокировкаИзмененияОбъектовГруппаВидимость = Не РазрешитьИзменениеОбъекта;
		БлокироватьФорму = БлокировкаИзмененияОбъектовГруппаВидимость;
	Иначе
		БлокировкаИзмененияОбъектовГруппаВидимость =
			УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта <> Неопределено
				И УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта.Количество() > 0;
		БлокироватьФорму = Ложь;
	КонецЕсли;
	
	Если БлокировкаИзмененияОбъектовГруппаВидимость = Истина Тогда
		
		БлокировкиИзменения = УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта;
		КоличествоПричинБлокировки = УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта.Количество();
		МаксимальноеКоличествоПричинФормы = 10;
		
		Если КоличествоПричинБлокировки > 0 Тогда
			
			БлокировкаИзмененияОбъектаРасшифровкиГруппа = УправляемаяФорма.Элементы.Найти("БлокировкаИзмененияОбъектаРасшифровкиГруппа");
			Если БлокировкаИзмененияОбъектаРасшифровкиГруппа <> Неопределено Тогда
				
				Если КоличествоПричинБлокировки = 1 Тогда
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.ОтображатьЗаголовок      = Ложь;
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.Поведение                = ПоведениеОбычнойГруппы.Обычное;
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.ЦветФона                 =
						БлокировкаИзмененияОбъектаРасшифровкиГруппа.Родитель.ЦветФона;
				Иначе
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.Заголовок                = СтрШаблон(
						НСтр("ru = 'Причины блокировки формы';
							|en = 'Form locking reasons'") + " (%1)",
						КоличествоПричинБлокировки);
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.ОтображатьЗаголовок      = Истина;
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.ОтображатьОтступСлева    = Ложь;
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.Поведение                = ПоведениеОбычнойГруппы.Всплывающая;
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.ОтображениеУправления    = ОтображениеУправленияОбычнойГруппы.ГиперссылкаЗаголовка;
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.Скрыть();
					БлокировкаИзмененияОбъектаРасшифровкиГруппа.ЦветФона                 = Новый Цвет();
				КонецЕсли;
				
				ЗаголовкиЕще = Новый Массив;
				ИдентификаторБлокировки = 0;
				Пока ИдентификаторБлокировки < Макс(КоличествоПричинБлокировки, МаксимальноеКоличествоПричинФормы) Цикл
					
					Если КоличествоПричинБлокировки - МаксимальноеКоличествоПричинФормы = 1 Тогда
						МаксимальноеКоличествоПричин = МаксимальноеКоличествоПричинФормы - 1;
					Иначе
						МаксимальноеКоличествоПричин = МаксимальноеКоличествоПричинФормы;
					КонецЕсли;
					
					Если ИдентификаторБлокировки < КоличествоПричинБлокировки Тогда
					
						Если ИдентификаторБлокировки < МаксимальноеКоличествоПричин Тогда
							ВывестиГруппуРасшифровки(УправляемаяФорма, БлокировкаИзмененияОбъектаРасшифровкиГруппа, ИдентификаторБлокировки, КоличествоПричинБлокировки = 1);
						Иначе
							ЗаголовкиЕще.Добавить(СтрШаблон(
								"%1. %2",
								Формат(ИдентификаторБлокировки + 1, "ЧН=; ЧГ="),
								БлокировкиИзменения[ИдентификаторБлокировки].Описание));
						КонецЕсли;
						
					КонецЕсли;
					
					Если ИдентификаторБлокировки >= Мин(КоличествоПричинБлокировки, МаксимальноеКоличествоПричин) Тогда
						СкрытьГруппуРасшифровки(УправляемаяФорма, БлокировкаИзмененияОбъектаРасшифровкиГруппа, ИдентификаторБлокировки);
					КонецЕсли;
					
					ИдентификаторБлокировки = ИдентификаторБлокировки + 1;
					
				КонецЦикла;
				
				ИмяДекорацииЕще = БлокировкаИзмененияОбъектаРасшифровкиГруппа.Имя + "_Еще";
				Если ЗаголовкиЕще.Количество() > 0 Тогда
					
					ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
						УправляемаяФорма.Элементы,
						ИмяДекорацииЕще,
						"Подсказка",
						СтрСоединить(ЗаголовкиЕще, Символы.ПС));
					
					ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
						УправляемаяФорма.Элементы,
						ИмяДекорацииЕще,
						"Заголовок",
						СтрокаСЧислом(НСтр("ru = ';Еще %1 причина ...; ;Еще %1 причины ...;Еще %1 причин ...;Еще %1 прич. ...';
											|en = ';%1 more reason ...; ;%1 more reasons ...; %1 more reasons ...; %1 more reasons ...'"),
							ЗаголовкиЕще.Количество(), ВидЧисловогоЗначения.Количественное));
					
				КонецЕсли;
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					УправляемаяФорма.Элементы,
					ИмяДекорацииЕще,
					"Видимость",
					ЗаголовкиЕще.Количество() > 0);
				
			КонецЕсли;
			
			БлокировкаИзмененияОбъектовПредупреждениеГруппа = УправляемаяФорма.Элементы.Найти("БлокировкаИзмененияОбъектовПредупреждениеГруппа");
			Если БлокировкаИзмененияОбъектовПредупреждениеГруппа <> Неопределено Тогда
				
				Если КоличествоПричинБлокировки = 1 Тогда
					ПояснениеДекорацияЗаголовок = НСтр("ru = 'Документ не редактируется по причине:';
														|en = 'The document is not being edited due to:'");
				Иначе
					ПояснениеДекорацияЗаголовок = НСтр("ru = 'Документ не редактируется по причинам:';
														|en = 'The document is not being edited due to:'");
				КонецЕсли;
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					УправляемаяФорма.Элементы,
					БлокировкаИзмененияОбъектовПредупреждениеГруппа.Имя + "_Пояснение",
					"Заголовок",
					ПояснениеДекорацияЗаголовок);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТолькоПросмотрФормы = БлокироватьФорму И БлокировкаИзмененияОбъектовГруппаВидимость;
	Если УправляемаяФорма.ТолькоПросмотр <> ТолькоПросмотрФормы Тогда
		
		Если РазрешитьИзменениеОбъекта <> Ложь Тогда
			УправляемаяФорма.ТолькоПросмотр = ТолькоПросмотрФормы;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"БлокировкаИзмененияОбъектовГруппа",
		"Видимость",
		БлокировкаИзмененияОбъектовГруппаВидимость);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"РазблокироватьФормуДляИзмененияОбъекта",
		"Видимость",
		БлокировкаИзмененияОбъектовГруппаВидимость);
	
КонецПроцедуры

Функция ФормаПроинициализирована(УправляемаяФорма) Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(УправляемаяФорма, "ПараметрыБлокировкиИзмененияОбъекта");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВывестиГруппуРасшифровки(УправляемаяФорма, ГруппаПредотвращенийИзменения, ИдентификаторБлокировки, ЕдинственнаяПричинаБлокировки)
	
	БлокировкиИзменения = УправляемаяФорма.ПараметрыБлокировкиИзмененияОбъекта;
	
	ИмяГруппыРасшифровки = ГруппаПредотвращенийИзменения.Имя + "_" + Формат(ИдентификаторБлокировки + 1, "ЧН=; ЧГ=");
	ИмяДекорацииРасшифровкиНомер = ИмяГруппыРасшифровки + "_Номер";
	ИмяДекорацииРасшифровкиНадпись = ИмяГруппыРасшифровки + "_Надпись";
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		ИмяДекорацииРасшифровкиНомер,
		"Видимость",
		Не ЕдинственнаяПричинаБлокировки);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		ИмяДекорацииРасшифровкиНадпись,
		"Заголовок",
		БлокировкиИзменения[ИдентификаторБлокировки].Описание);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		ИмяГруппыРасшифровки,
		"Видимость",
		Истина);
	
КонецПроцедуры

Процедура СкрытьГруппуРасшифровки(УправляемаяФорма, ГруппаПредотвращенийИзменения, ИдентификаторБлокировки)
	
	ИмяГруппыРасшифровки = ГруппаПредотвращенийИзменения.Имя + "_" + Формат(ИдентификаторБлокировки + 1, "ЧН=; ЧГ=");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		ИмяГруппыРасшифровки,
		"Видимость",
		Ложь);
	
КонецПроцедуры

#КонецОбласти

