////////////////////////////////////////////////////////////////////////////////
// НСИ производства: Процедуры подсистемы управления данными об изделиях
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Спецификации

// Открывает форму выбора спецификаций по номенклатуре
//
// Параметры:
//  ДанныеОбИзделии				 - см. УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураДанныхОбИзделииДляВыбораСпецификации
//  ПараметрыВыбораСпецификаций	 - см. УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций
//  Владелец					 - ФормаКлиентскогоПриложения		- владелец формы.
//
Процедура ОткрытьФормуВыбораСпецификацийПоНоменклатуре(ДанныеОбИзделии, ПараметрыВыбораСпецификаций = Неопределено, Владелец = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	Для каждого КлючИЗначение Из ДанныеОбИзделии Цикл
		ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Если ПараметрыВыбораСпецификаций <> Неопределено Тогда
		ИсточникПараметров = ПараметрыВыбораСпецификаций;
	Иначе
		ИсточникПараметров = УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификацийНаИзготовлениеСборку();
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ИсточникПараметров Цикл
		Если КлючИЗначение.Ключ <> "ПолучитьСпецификацииПоНоменклатуре"
			И КлючИЗначение.Ключ <> "ПолучитьСпецификацииПоСпискуНоменклатуры" Тогда
			ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы.Вставить("ПолучитьСпецификацииПоНоменклатуре", Истина);
	
	ОткрытьФорму("Справочник.РесурсныеСпецификации.Форма.ФормаВыбораПоНоменклатуре", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Открывает форму выбора спецификаций по списку номенклатуры
//
// Параметры:
//  ДанныеОбИзделиях			 - см. УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураДанныхОбИзделииДляВыбораСпецификации
//  ПараметрыВыбораСпецификаций	 - см. УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций
//  Владелец					 - ФормаКлиентскогоПриложения	 - владелец формы.
//  ОписаниеОповещения			 - ОписаниеОповещения - описание оповещения.
//
Процедура ОткрытьФормуВыбораСпецификацийПоСпискуНоменклатуры(ДанныеОбИзделиях, ПараметрыВыбораСпецификаций = Неопределено, Владелец = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ДанныеОбИзделиях", ДанныеОбИзделиях);
	
	Если ПараметрыВыбораСпецификаций <> Неопределено Тогда
		ИсточникПараметров = ПараметрыВыбораСпецификаций;
	Иначе
		ИсточникПараметров = УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификацийНаИзготовлениеСборку();
	КонецЕсли;
	Для каждого КлючИЗначение Из ИсточникПараметров Цикл
		Если КлючИЗначение.Ключ <> "ПолучитьСпецификацииПоНоменклатуре"
			И КлючИЗначение.Ключ <> "ПолучитьСпецификацииПоСпискуНоменклатуры" Тогда
			ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	ПараметрыФормы.Вставить("ПолучитьСпецификацииПоСпискуНоменклатуры", Истина);
	
	ОткрытьФорму(
		"Справочник.РесурсныеСпецификации.Форма.ФормаВыбораПоНоменклатуре",
		ПараметрыФормы,
		Владелец,,,,
		ОписаниеОповещения);
		
КонецПроцедуры

// Копирует спецификацию и производственный процесс
//
// Параметры:
//  Источник							- СправочникСсылка.РесурсныеСпецификации - спецификация, которую нужно скопировать
//  ОписаниеОбработкиПослеКопирования	- ОписаниеОповещения - содержит описание процедуры, которую нужно вызвать после копирования.
//
Процедура КопироватьРесурснуюСпецификацию(Источник, ОписаниеОбработкиПослеКопирования = Неопределено) Экспорт

	ТекстВопроса = НСтр("ru = 'Будет создана и записана копия ресурсной спецификации.
								|Скопировать?';
								|en = 'A BOM copy will be created and saved.
								|Do you want to copy?'");
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Скопировать';
														|en = 'Copy'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
	
	ДополнительныеПараметры = Новый Структура("Источник,ОписаниеОбработкиПослеКопирования", Источник, ОписаниеОбработкиПослеКопирования);
	ОписаниеОповещения = Новый ОписаниеОповещения("КопироватьРесурснуюСпецификациюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

// Устанавливает новый статус для спецификаций
//
// Параметры:
//	НовыйСтатус				- ПеречислениеСсылка.СтатусыСпецификаций - новый статус
//	ПредставлениеСтатуса	- Строка - представление нового статуса
//  МассивСпецификаций		- Массив - список спецификаций.
//
Процедура УстановитьСтатусСпецификаций(НовыйСтатус, ПредставлениеСтатуса, МассивСпецификаций) Экспорт
	
	Если МассивСпецификаций.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗначениеСтатуса",      НовыйСтатус);
	ДополнительныеПараметры.Вставить("ПредставлениеСтатуса", ПредставлениеСтатуса);
	ДополнительныеПараметры.Вставить("ВыделенныеСсылки",     МассивСпецификаций);
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьСтатусСпецификацийЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Выбранным спецификациям будет установлен статус ""%1"". Продолжить?';
						|en = 'Status ""%1"" will be set for the selected BOMs. Continue?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ПредставлениеСтатуса);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

//++ Устарело_Производство21

//++ НЕ УТКА

// Открывает форму для ввода параметров новой спецификации
//
// Параметры:
//	ТекущиеДанные		- ДанныеФормыСтруктура - содержит данные о продукции:
//  						* Номенклатура		- СправочникСсылка.Номенклатура - производимое изделие
//  						* Характеристика	- СправочникСсылка.ХарактеристикиНоменклатуры - характеристика производимого изделия
//  						* Спецификация		- СправочникСсылка.РесурсныеСпецификации - основная спецификация
//  ОписаниеОповещения	- ОписаниеОповещения - обработчик завершения ввода параметров, расположенный в контексте данных спецификации заказа.
//
Процедура СоздатьСпецификациюНаОснованииСпецификацииЗаказа(ТекущиеДанные, ОписаниеОповещения) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура",   ТекущиеДанные.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	ПараметрыФормы.Вставить("Спецификация",   ТекущиеДанные.Спецификация);
	
	ОткрытьФорму("Документ.ЗаказНаПроизводство.Форма.СозданиеСпецификацииНаОснованииСпецификацииЗаказа", ПараметрыФормы,,,,, ОписаниеОповещения);
	
КонецПроцедуры

//-- НЕ УТКА

//-- Устарело_Производство21

#КонецОбласти

//++ НЕ УТКА

#Область МаршрутныеКарты

// Формирует оповещение о записи основной маршрутной карты.
// Используется для обновления данных в формах и для информирования пользователя о завершенной операции.
//
// Параметры:
//  СвойстваЗаписи - Структура, РегистрСведенийЗапись.ОсновныеМаршрутныеКарты - содержит значения свойств записи.
//  НавигационнаяСсылка - Строка - навигационная ссылка на измененную запись.
//
Процедура ОповеститьОЗаписиОсновнойМаршрутнойКарты(СвойстваЗаписи = Неопределено, НавигационнаяСсылка = Неопределено) Экспорт
	
	Если СвойстваЗаписи <> Неопределено Тогда
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Подразделение",   СвойстваЗаписи.Подразделение);
		СтруктураЗаписи.Вставить("Номенклатура",    СвойстваЗаписи.Номенклатура);
		СтруктураЗаписи.Вставить("Характеристика",  СвойстваЗаписи.Характеристика);
		СтруктураЗаписи.Вставить("МаршрутнаяКарта", СвойстваЗаписи.МаршрутнаяКарта);
	Иначе
		СтруктураЗаписи = Неопределено;
	КонецЕсли; 
	
	Оповестить("Запись_ОсновныеМаршрутныеКарты", СтруктураЗаписи);
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ОсновныеМаршрутныеКарты"));
	
	Если НавигационнаяСсылка <> Неопределено Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменена основная маршрутная карта';
											|en = 'Main route sheet is changed'"), НавигационнаяСсылка);
		ИсторияРаботыПользователя.Добавить(НавигационнаяСсылка);
	КонецЕсли; 
	
КонецПроцедуры

// Устанавливает новый статус для спецификаций
//
// Параметры:
//	НовыйСтатус				- ПеречислениеСсылка.СтатусыСпецификаций - новый статус
//	ПредставлениеСтатуса	- Строка - представление нового статуса
//  МассивОбъектов			- Массив - список маршрутных карт.
//
Процедура УстановитьСтатусМаршрутныхКарт(НовыйСтатус, ПредставлениеСтатуса, МассивОбъектов) Экспорт
	
	Если МассивОбъектов.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗначениеСтатуса",      НовыйСтатус);
	ДополнительныеПараметры.Вставить("ПредставлениеСтатуса", ПредставлениеСтатуса);
	ДополнительныеПараметры.Вставить("ВыделенныеСсылки",     МассивОбъектов);
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьСтатусМаршрутныхКартЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Выбранным маршрутным картам будет установлен статус ""%1"". Продолжить?';
						|en = 'Status ""%1"" will be set for the selected route sheets. Continue?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ПредставлениеСтатуса);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

//-- НЕ УТКА

//++ НЕ УТКА

#Область Автовыбор_ОтборПоСвойствам_РасчетКоличества

// Открывает форму настройки автовыбора номенклатуры
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма из которой вызывается настройка автовыбора
//  ИмяТЧ - Строка - имя табличной части
//  СоответствиеСвойств	- ТабличнаяЧасть - содержит свойства по которым выполняется автовыбор характеристики
//  ВидИзделийИлиНоменклатура - СправочникСсылка.ВидыНоменклатуры - определяет список доступных свойств для выбора
//  НазваниеСвойстваУказываетсяВНСИ - Строка - заголовок значения перечисления УказываетсяВНСИ
//  ТолькоПросмотр - Булево - открыть форму только для просмотра.
//
Процедура НастроитьАвтовыборНоменклатуры(
	ФормаВладелец,
	ИмяТЧ,
	СоответствиеСвойств,
	ВидИзделийИлиНоменклатура,
	НазваниеСвойстваУказываетсяВНСИ,
	ТолькоПросмотр = Ложь) Экспорт
	
	ДанныеСтроки = ФормаВладелец.Элементы[ИмяТЧ].ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ПараметрыФормы.Вставить("СоответствиеСвойств", СоответствиеСвойств);
	
	ПараметрыФормы.Вставить("ВидИзделийИлиНоменклатура",        ВидИзделийИлиНоменклатура);
	ПараметрыФормы.Вставить("СвойствоСодержащееНоменклатуру",   ДанныеСтроки.СвойствоСодержащееНоменклатуру);
	ПараметрыФормы.Вставить("СпособАвтовыбораНоменклатуры",     ДанныеСтроки.СпособАвтовыбораНоменклатуры);
	ПараметрыФормы.Вставить("СпособАвтовыбораХарактеристики",   ДанныеСтроки.СпособАвтовыбораХарактеристики);
	ПараметрыФормы.Вставить("АлгоритмАвтовыбораХарактеристики", ДанныеСтроки.АлгоритмАвтовыбораХарактеристики);
	
	ПараметрыФормы.Вставить("Номенклатура",   ДанныеСтроки.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", ДанныеСтроки.Характеристика);
	
	ПараметрыФормы.Вставить("Описание", Неопределено);
	Если НЕ ДанныеСтроки.Свойство("ПрименениеМатериала", ПараметрыФормы.Описание) Тогда
		ДанныеСтроки.Свойство("ОписаниеИзделия", ПараметрыФормы.Описание);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ИмяТЧ", ИмяТЧ);
	ПараметрыФормы.Вставить("НазваниеСвойстваУказываетсяВНСИ", НазваниеСвойстваУказываетсяВНСИ);
	
	ОткрытьФорму("ОбщаяФорма.НастройкаАвтовыбораНоменклатуры", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Открывает форму настройки отбора по свойствам и алгоритма расчета количества
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма из которой вызывается настройка
//  ИмяТЧ - Строка - имя таблицы (МатериалыИУслуги, Трудозатраты, ВидыРабочихЦентров)
//  ОтборПоСвойствам - ТабличнаяЧасть - табличная часть с отборами по свойствам
//  ВидИзделийИлиНоменклатура  - СправочникСсылка.ВидыНоменклатуры - определяет список доступных свойств для выбора
//  ТолькоПросмотр - Булево - открыть форму только для просмотра
//  СоставНастроек  - Структура  - настройки открытия формы
//  АдресДополнительныхДанных  - Строка  - 
//
Процедура НастроитьОтборПоСвойствамИРасчетПоФормулам(
	ФормаВладелец,
	ИмяТЧ,
	ОтборПоСвойствам,
	ВидИзделийИлиНоменклатура,
	ТолькоПросмотр,
	СоставНастроек = Неопределено,
	АдресДополнительныхДанных = "") Экспорт
	
	ДанныеСтроки = ФормаВладелец.Элементы[ИмяТЧ].ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура(
		"ИмяТЧ,
		|ТолькоПросмотр,
		|СоставНастроек,
		|
		|АлгоритмРасчетаКоличества,
		|
		|ВидИзделийИлиНоменклатура,
		|АдресДополнительныхДанных
		|");
	
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, ДанныеСтроки);
	
	ПараметрыФормы.ИмяТЧ = ИмяТЧ;
	
	ПараметрыФормы.ТолькоПросмотр = ТолькоПросмотр;
	ПараметрыФормы.СоставНастроек = СоставНастроек;
	
	ПараметрыФормы.ВидИзделийИлиНоменклатура = ВидИзделийИлиНоменклатура;
	ПараметрыФормы.АдресДополнительныхДанных = АдресДополнительныхДанных;
	
	ПараметрыФормы.Вставить("ОтборПоСвойствам", ОтборПоСвойствам);
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОтбораПоСвойствамИРасчетаПоФормулам", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Выполняет действия при удалении из табличной части
// - удаляет настройки автовыбора.
//
// Параметры:
//  ТаблицаФормы				- ТаблицаФормы - таблица формы на которой расположен список номенклатуры
//  ВыделенныеСтроки			- Массив - содержит массив идентификаторов выделенных строк
//  СоответствиеСвойств			- ДанныеФормыКоллекция - табличная часть "СоответствиеСвойств".
//
Процедура ОчиститьНастройкиАвтовыбораНоменклатуры(ТаблицаФормы, ВыделенныеСтроки, СоответствиеСвойств) Экспорт

	Для каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		ДанныеСтроки = ТаблицаФормы.ДанныеСтроки(ИдентификаторСтроки);
		
		УправлениеДаннымиОбИзделияхКлиентСервер.ОчиститьНастройкиАвтовыбораПоСтроке(
			ДанныеСтроки,
			СоответствиеСвойств);
		
	КонецЦикла; 
	
КонецПроцедуры

// Выполняет действия при удалении из табличной части
// - удаляет настройки отбора по свойствам
//
// Параметры:
//  ТаблицаФормы				- ТаблицаФормы - таблица формы на которой расположен список номенклатуры
//  ВыделенныеСтроки			- Массив - содержит массив идентификаторов выделенных строк
//  ОтборПоСвойствам			- ДанныеФормыКоллекция - табличная часть "ОтборПоСвойствам"
//
Процедура ОчиститьНастройкиОтбораПоСвойствам(ТаблицаФормы, ВыделенныеСтроки, ОтборПоСвойствам) Экспорт
	
	Для каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		ДанныеСтроки = ТаблицаФормы.ДанныеСтроки(ИдентификаторСтроки);
		
		УправлениеДаннымиОбИзделияхКлиентСервер.ОчиститьНастройкиОтбораПоСвойствамПоСтроке(
			ДанныеСтроки,
			ОтборПоСвойствам);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

//-- НЕ УТКА

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет действия при удалении видов рабочих центров из табличной части
// - удаляет альтернативные виды рабочих центров.
//
// Параметры:
//  ТаблицаФормы								- ТаблицаФормы - таблица формы на которой расположен список видов рабочих центров
//  АльтернативныеВидыРабочихЦентров			- ДанныеФормыКоллекция - табличная часть, содержащая альтернативные виды рабочих центров.
//
Процедура ПередУдалениемВидовРабочихЦентров(ТаблицаФормы, АльтернативныеВидыРабочихЦентров) Экспорт

	ВыделенныеСтроки = ТаблицаФормы.ВыделенныеСтроки;
	Для каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		ДанныеСтроки = ТаблицаФормы.ДанныеСтроки(ИдентификаторСтроки);
		
		СтруктураПоиска = Новый Структура("КлючСвязиВидыРабочихЦентров", ДанныеСтроки.КлючСвязи);
		СписокСтрок = АльтернативныеВидыРабочихЦентров.НайтиСтроки(СтруктураПоиска);
		Для каждого НайденнаяСтрока Из СписокСтрок Цикл
			АльтернативныеВидыРабочихЦентров.Удалить(НайденнаяСтрока);
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры

// Оповещение копирования ресурсной спецификации
// 
// Параметры:
// 	РезультатВопроса - КодВозвратаДиалога - выбор пользователя
// 	ДополнительныеПараметры - Структура - из:
//		* Источник - СправочникСсылка.РесурсныеСпецификации - копируемая спецификация
//		* ОписаниеОбработкиПослеКопирования - Строка - имя процедуры
Процедура КопироватьРесурснуюСпецификациюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Ссылка = УправлениеДаннымиОбИзделияхВызовСервера.КопироватьРесурснуюСпецификацию(ДополнительныеПараметры.Источник);
	
	КопироватьРесурснуюСпецификациюПослеКопирования(Ссылка, ДополнительныеПараметры.ОписаниеОбработкиПослеКопирования);
	
КонецПроцедуры

Процедура КопироватьРесурснуюСпецификациюПослеКопирования(Ссылка, ОписаниеОбработкиПослеКопирования = Неопределено) Экспорт
	
	Если Ссылка <> Неопределено Тогда
		
		ОповеститьОбИзменении(Тип("СправочникСсылка.РесурсныеСпецификации"));
		Оповестить("Запись_ЭтапыПроизводства");
		ПоказатьЗначение(, Ссылка);
		
		ПоказатьОповещениеПользователя(
				НСтр("ru = 'Создание:';
					|en = 'Create:'"), 
				ПолучитьНавигационнуюСсылку(Ссылка), 
				Ссылка);
		
		Если ОписаниеОбработкиПослеКопирования <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОписаниеОбработкиПослеКопирования, Ссылка);
		КонецЕсли; 
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось скопировать ресурсную спецификацию.';
										|en = 'Cannot copy BOM.'"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСтатусСпецификацийЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	КоличествоОбработанных = УправлениеДаннымиОбИзделияхВызовСервера.УстановитьСтатусСпецификаций(
										ДополнительныеПараметры.ВыделенныеСсылки, 
										ДополнительныеПараметры.ЗначениеСтатуса);
										
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(
			Неопределено,
			КоличествоОбработанных, 
			ДополнительныеПараметры.ВыделенныеСсылки.Количество(), 
			ДополнительныеПараметры.ПредставлениеСтатуса);
			
	Оповестить("Запись_РесурсныеСпецификации");
	ОповеститьОбИзменении(Тип("СправочникСсылка.РесурсныеСпецификации"));
	
КонецПроцедуры

//++ НЕ УТКА

Процедура УстановитьСтатусМаршрутныхКартЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	КоличествоОбработанных = УправлениеДаннымиОбИзделияхВызовСервера.УстановитьСтатусМаршрутныхКарт(
										ДополнительныеПараметры.ВыделенныеСсылки, 
										ДополнительныеПараметры.ЗначениеСтатуса);
										
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(
			Неопределено,
			КоличествоОбработанных, 
			ДополнительныеПараметры.ВыделенныеСсылки.Количество(), 
			ДополнительныеПараметры.ПредставлениеСтатуса);
			
	Оповестить("Запись_МаршрутныеКарты");
	ОповеститьОбИзменении(Тип("СправочникСсылка.МаршрутныеКарты"));
	
КонецПроцедуры

//-- НЕ УТКА

//++ НЕ УТКА

#Область Автовыбор_ОтборПоСвойствам_РасчетКоличества

// Оповещение о завершении настройки автовыбора
// 
// Параметры:
// 	РезультатНастройки - Структура - результат настройки:
// 		* Описание - Строка - описание настройки
// 	ДанныеСтроки - ДанныеФормыЭлементКоллекции - данные строки
// 	СоответствиеСвойств - ДанныеФормыКоллекция - таблица настройки соответствия свойств
// Возвращаемое значение:
// 	Булево - Статус результата
//
Функция НастроитьАвтовыборНоменклатурыЗавершение(РезультатНастройки, ДанныеСтроки, СоответствиеСвойств) Экспорт

	Если РезультатНастройки = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДанныеСтроки,
							РезультатНастройки,
							"Номенклатура,Характеристика,НоменклатураСтрокой,ХарактеристикаСтрокой,
							|СпособАвтовыбораНоменклатуры,СпособАвтовыбораХарактеристики,
							|АлгоритмАвтовыбораХарактеристики, СвойствоСодержащееНоменклатуру");
	
	Если ДанныеСтроки.Свойство("ПрименениеМатериала") Тогда
		ДанныеСтроки.ПрименениеМатериала = РезультатНастройки.Описание;
	ИначеЕсли ДанныеСтроки.Свойство("ОписаниеИзделия") Тогда
		ДанныеСтроки.ОписаниеИзделия = РезультатНастройки.Описание;
	КонецЕсли;
	
	// Удалим старые настройки
	СтруктураПоиска = Новый Структура("КлючСвязи", ДанныеСтроки.КлючСвязи);
	СписокСтрок = СоответствиеСвойств.НайтиСтроки(СтруктураПоиска);
	Для каждого СтрокаСоответствие Из СписокСтрок Цикл
		СоответствиеСвойств.Удалить(СтрокаСоответствие);
	КонецЦикла;
	
	// Обновим данные
	Если ЗначениеЗаполнено(РезультатНастройки.СоответствиеСвойств) Тогда
		Для каждого Элемент Из РезультатНастройки.СоответствиеСвойств Цикл
			НастройкаСоответствия = СоответствиеСвойств.Добавить();
			ЗаполнитьЗначенияСвойств(НастройкаСоответствия, Элемент);
			НастройкаСоответствия.КлючСвязи = ДанныеСтроки.КлючСвязи;
		КонецЦикла;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",    ДанныеСтроки.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ДанныеСтроки.Упаковка);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ДанныеСтроки, СтруктураДействий, Неопределено);
	
	Возврат Истина;
	
КонецФункции

Функция НастроитьОтборПоСвойствамИРасчетПоФормуламЗавершение(РезультатНастройки, ДанныеСтроки, ОтборПоСвойствам) Экспорт

	Если РезультатНастройки = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДанныеСтроки.АлгоритмРасчетаКоличества = РезультатНастройки.АлгоритмРасчетаКоличества;
	ДанныеСтроки.РасчетПоФормуле = НЕ ПустаяСтрока(ДанныеСтроки.АлгоритмРасчетаКоличества);
	
	ОбновитьНастройкиОтбораПоСвойствамПоКлючу(ОтборПоСвойствам, РезультатНастройки.ОтборПоСвойствам, ДанныеСтроки.КлючСвязи);
	
	ДанныеСтроки.УстановленОтборПоСвойствам = РезультатНастройки.ОтборПоСвойствам.Количество() > 0;
	
	Возврат Истина;
	
КонецФункции

Процедура ОбновитьНастройкиОтбораПоСвойствамПоКлючу(Таблица, Настройка, КлючСвязи) Экспорт
	
	СтруктураПоиска = Новый Структура("КлючСвязи", КлючСвязи);
	СписокСтрок = Таблица.НайтиСтроки(СтруктураПоиска);
	Для каждого СтрокаУсловие Из СписокСтрок Цикл
		Таблица.Удалить(СтрокаУсловие);
	КонецЦикла;
	
	Для каждого Условие Из Настройка Цикл
		НоваяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Условие);
		НоваяСтрока.КлючСвязи = КлючСвязи;
	КонецЦикла;
	
КонецПроцедуры

Функция РеквизитыНастроекПоСтрокеВМассивСтруктур(ДанныеСтроки, ТаблицаНастроек, СписокРеквизитов) Экспорт
	
	Результат = Новый Массив;
	
	СтруктураПоиска = Новый Структура("КлючСвязи", ДанныеСтроки.КлючСвязи);
	
	СписокСтрок = ТаблицаНастроек.НайтиСтроки(СтруктураПоиска);
	Для каждого Строка Из СписокСтрок Цикл
		СтруктураДанныхСтроки = Новый Структура(СписокРеквизитов);
		ЗаполнитьЗначенияСвойств(СтруктураДанныхСтроки, Строка);
		Результат.Добавить(СтруктураДанныхСтроки);
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

Процедура ОтборПоСвойствамПередНачаломИзменения(
	Форма,
	ТекущиеДанные,
	ТаблицаДоступныхСвойств,
	СтруктураУсловий) Экспорт
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойств.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоСвойствамУстановитьОграничениеТиповДляЗначения(Форма, ТекущиеДанные, СтруктураУсловий, СтрокиТаблицыСвойств[0].ТипЗначения);
	
КонецПроцедуры

Процедура ОтборПоСвойствамСвойствоПриИзменении(
	Форма,
	ТекущиеДанные,
	ТаблицаДоступныхСвойств,
	СтруктураУсловий) Экспорт
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойств.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Условие  = "Равно";
	
	ТипЗначенияПриведенный = 
		ОтборПоСвойствамУстановитьОграничениеТиповДляЗначения(Форма, ТекущиеДанные, СтруктураУсловий, СтрокиТаблицыСвойств[0].ТипЗначения);
	
	ТекущиеДанные.Значение = ТипЗначенияПриведенный.ПривестиЗначение(Неопределено);
	
КонецПроцедуры

Процедура ОтборПоСвойствамУсловиеПриИзменении(
	Форма,
	ТекущиеДанные,
	ТаблицаДоступныхСвойств,
	СтруктураУсловий) Экспорт
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойств.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееУсловие = СтруктураУсловий[ТекущиеДанные.Условие];
	
	ТипЗначенияПриведенный = 
		ОтборПоСвойствамУстановитьОграничениеТиповДляЗначения(Форма, ТекущиеДанные, СтруктураУсловий, СтрокиТаблицыСвойств[0].ТипЗначения);
	
	Если ТекущееУсловие.Список Тогда
		
		ТекущиеДанные.Значение = Новый СписокЗначений;
		ТекущиеДанные.Значение.ТипЗначения = ТипЗначенияПриведенный;
		
	Иначе
		
		Если ТекущееУсловие.Интервал ИЛИ ТекущееУсловие.Заполненность Тогда
			ТекущиеДанные.Значение = Неопределено;
		КонецЕсли;
		
		ТекущиеДанные.Значение = ТипЗначенияПриведенный.ПривестиЗначение(ТекущиеДанные.Значение);
		
	КонецЕсли;
	
	Для Ит = 1 По 2 Цикл
		ТекущиеДанные["Значение"+Ит] = ТипЗначенияПриведенный.ПривестиЗначение(Неопределено);
	КонецЦикла;
	
КонецПроцедуры

// Обработчик начала выбора условия при отборе по свойствам
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения- форма
// 	ТекущиеДанные - ДанныеФормыЭлементКоллекции - строка таблицы формы
// 	ТаблицаДоступныхСвойств - ТаблицаЗначений - доступные свойства
// 	СтруктураУсловий - Структура - условия
Процедура ОтборПоСвойствамУсловиеНачалоВыбора(
	Форма,
	ТекущиеДанные,
	ТаблицаДоступныхСвойств,
	СтруктураУсловий) Экспорт
	
	СписокВыбора = Форма.Элементы.Условие.СписокВыбора;
	СписокВыбора.Очистить();
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойств.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из СтруктураУсловий Цикл
		Условие = КлючИЗначение.Значение; // см. УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураУсловияОтбораПоСвойствамНоменклатуры
		Если Условие.Сравнение 
			И НЕ СтрокиТаблицыСвойств[0].ТипЗначения.СодержитТип(Тип("Число"))
			И НЕ СтрокиТаблицыСвойств[0].ТипЗначения.СодержитТип(Тип("Дата"))
		Тогда
			Продолжить;
		КонецЕсли;
		СписокВыбора.Добавить(Условие.Идентификатор, Условие.Представление);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтборПоСвойствамЗначениеИнтервалПриИзменении(ТекущиеДанные, ИмяРеквизита) Экспорт

	ТипЗначенияОтбора = Новый ОписаниеТипов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(ТекущиеДанные[ИмяРеквизита])));
	
	Для Ит = 1 По 2 Цикл
		ТекущиеДанные["Значение"+Ит] = ТипЗначенияОтбора.ПривестиЗначение(ТекущиеДанные["Значение"+Ит]);
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает ограничение типа для элемента отбора по свойствам
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения- форма
// 	ТекущиеДанные - ДанныеФормыЭлементКоллекции - строка таблицы формы - из:
// 		* Условие - Строка - идентификатор условия
// 	СтруктураУсловий - Структура - условия
// 	ТипЗначения - ОписаниеТипов - тип значения исходный
// Возвращаемое значение:
// 	ОписаниеТипов - тип значения приведенный
Функция ОтборПоСвойствамУстановитьОграничениеТиповДляЗначения(
	Форма,
	ТекущиеДанные,
	СтруктураУсловий,
	ТипЗначения) Экспорт
	
	ТекущееУсловие = СтруктураУсловий[ТекущиеДанные.Условие]; // см. УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураУсловияОтбораПоСвойствамНоменклатуры
	
	Если ТекущееУсловие.Сравнение Тогда
		ВычитаемыеТипы = Новый Массив;
		Для каждого Тип Из ТипЗначения.Типы() Цикл
			Если НЕ Тип = Тип("Дата") И НЕ Тип = Тип("Число") Тогда
				ВычитаемыеТипы.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		ТипЗначенияПриведенный = Новый ОписаниеТипов(ТипЗначения,,ВычитаемыеТипы);
	Иначе
		ТипЗначенияПриведенный = ТипЗначения;
	КонецЕсли;
	
	ПараметрыВыбора = Новый Массив;
	Если ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ТекущиеДанные.Свойство));
	КонецЕсли;
	
	Форма.Элементы.Значение.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	Если ТекущееУсловие.Список Тогда
		Форма.Элементы.Значение.ОграничениеТипа = Новый ОписаниеТипов("СписокЗначений");
	ИначеЕсли ТекущееУсловие.Интервал Тогда
		Форма.Элементы.Значение1.ОграничениеТипа = ТипЗначенияПриведенный;
		Форма.Элементы.Значение2.ОграничениеТипа = ТипЗначенияПриведенный;
	Иначе
		Форма.Элементы.Значение.ОграничениеТипа  = ТипЗначенияПриведенный;
	КонецЕсли;
	
	Возврат ТипЗначенияПриведенный;
	
КонецФункции

// Производит контроль правильности настройки отбора по свойствам
// 
// Параметры:
// 	ОтборПоСвойствам - ДанныеФормыКоллекция - таблица заданных отборов
// 	ТаблицаДоступныхСвойств - ДанныеФормыКоллекция - таблица свойств
// 	ЕстьОшибки - Булево - признак наличия ошибок
// Возвращаемое значение:
// 	Массив - массив элементов настройки
//
Функция ОтборПоСвойствамПроизвестиКонтрольСформироватьРезультатНастройки(
	ОтборПоСвойствам,
	ТаблицаДоступныхСвойств,
	ЕстьОшибки) Экспорт
	
	ШаблонПолеНеЗаполнено  = НСтр("ru = 'Ошибка заполнения настройки в строке %1.';
									|en = 'An error occurred when filling in settings in line %1.'");
	ШаблонНеверноеСвойство = НСтр("ru = 'Указано неверное свойство в строке %1.';
									|en = 'Incorrect property is specified in line %1.'");
	ШаблонНеверноеУсловие  = НСтр("ru = 'Ошибка заполнения настройки в строке %1. Левое значение не может быть больше правого.';
									|en = 'An error occurred when filling in settings in line %1. The left value cannot be greater than the right one.'");
	ШаблонПутьКДанным      = "ОтборПоСвойствам[%1].%2";
	
	Реквизиты        = УправлениеДаннымиОбИзделияхКлиентСервер.РеквизитыНастройкаОтбораПоСвойствам();
	СтруктураУсловий = УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураУсловийОтбораПоСвойствамНоменклатуры();
	
	Результат = Новый Массив;
	
	Для каждого СтрокаОтбора Из ОтборПоСвойствам Цикл
		
		Если ПустаяСтрока(СтрокаОтбора.Условие) Тогда
			Продолжить;
		КонецЕсли;
		
		ИндексСтроки = ОтборПоСвойствам.Индекс(СтрокаОтбора);
		
		ТекущееУсловие = СтруктураУсловий[СтрокаОтбора.Условие]; // см. УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураУсловияОтбораПоСвойствамНоменклатуры
		
		Если ТекущееУсловие.Интервал Тогда
			Если СтрокаОтбора.Значение1 <> Неопределено
				И СтрокаОтбора.Значение2 <> Неопределено
				И СтрокаОтбора.Значение1 > СтрокаОтбора.Значение2 Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(ШаблонНеверноеУсловие,ИндексСтроки+1),,
					СтрШаблон(ШаблонПутьКДанным, ИндексСтроки, "Значение1"),,
					ЕстьОшибки);
				Продолжить;
			КонецЕсли;
			ПоляПроверки = СтрРазделить(СтрЗаменить(Реквизиты,"Значение","Значение1,Значение2"), ",");
		Иначе
			ПоляПроверки = СтрРазделить(Реквизиты, ",");
		КонецЕсли;
		
		Для каждого Поле Из ПоляПроверки Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаОтбора[Поле])
				И НЕ СтрокаОтбора[Поле] = 0 
				И НЕ ТекущееУсловие.Заполненность Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(ШаблонПолеНеЗаполнено,ИндексСтроки+1),,
					СтрШаблон(ШаблонПутьКДанным, ИндексСтроки, Поле),,
					ЕстьОшибки);
			ИначеЕсли Поле = "Свойство" 
					И ТаблицаДоступныхСвойств.НайтиСтроки(Новый Структура("Свойство", СтрокаОтбора[Поле])).Количество() = 0 Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(ШаблонНеверноеСвойство,ИндексСтроки+1),,
					СтрШаблон(ШаблонПутьКДанным, ИндексСтроки, Поле),,
					ЕстьОшибки);
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьОшибки Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекущееУсловие.Список Тогда
			Для каждого ЭлементСписка Из СтрокаОтбора.Значение Цикл
				ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
				ЗаполнитьЗначенияСвойств(ЭлементНастройкиУсловия, СтрокаОтбора);
				ЭлементНастройкиУсловия.Значение = ЭлементСписка.Значение;
				Результат.Добавить(ЭлементНастройкиУсловия);
			КонецЦикла;
		ИначеЕсли ТекущееУсловие.Интервал Тогда
			ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
			ЭлементНастройкиУсловия.Свойство = СтрокаОтбора.Свойство;
			ЭлементНастройкиУсловия.Условие  = ?(ТекущееУсловие.Идентификатор = "ВИнтервале", "Больше", "БольшеИлиРавно");
			ЭлементНастройкиУсловия.Значение = СтрокаОтбора.Значение1;
			Результат.Добавить(ЭлементНастройкиУсловия);
			
			ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
			ЭлементНастройкиУсловия.Свойство = СтрокаОтбора.Свойство;
			ЭлементНастройкиУсловия.Условие  = ?(ТекущееУсловие.Идентификатор = "ВИнтервале", "Меньше", "МеньшеИлиРавно");
			ЭлементНастройкиУсловия.Значение = СтрокаОтбора.Значение2;
			Результат.Добавить(ЭлементНастройкиУсловия);
		Иначе
			ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
			ЗаполнитьЗначенияСвойств(ЭлементНастройкиУсловия, СтрокаОтбора);
			Результат.Добавить(ЭлементНастройкиУсловия);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

//-- НЕ УТКА

//++ НЕ УТКА

Процедура ПоказатьВопросКопироватьМаршрутнуюКартуСОперациями(ОписаниеОповещения) Экспорт
	
	ТекстВопроса = НСтр("ru = 'Будет создана и записана копия маршрутной карты (включая техоперации).
								|Скопировать?';
								|en = 'A copy of the route sheet will be created and saved (including manufacturing operations).
								|Continue?'");
	СписокКнопок = Новый СписокЗначений;								
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Скопировать';
														|en = 'Copy'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

Процедура ОповеститьОКопированииМаршрутнойКартыСОперациями() Экспорт
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.МаршрутныеКарты"));
	Оповестить("Запись_ТехнологическиеОперации");
	
КонецПроцедуры

//-- НЕ УТКА

#Область ДеревоСпецификаций

Процедура СохранитьРазвернутыеУровниДерева(Форма, СтрокаДерева = Неопределено) Экспорт
	
	Форма.РазвернутыеУровниДерева = Новый Структура;
	
	СохранитьСостояниеУровняДерева(Форма, 0, Новый Массив, ?(СтрокаДерева = Неопределено, Форма.ДеревоСпецификаций, СтрокаДерева));
	
КонецПроцедуры

Процедура ВосстановитьРазвернутыеУровниДерева(Форма, СтрокаДерева = Неопределено) Экспорт
	
	Если Форма.РазвернутыеУровниДерева = Неопределено ИЛИ Форма.РазвернутыеУровниДерева.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВосстановитьСостояниеУровняДерева(Форма, 0, Новый Массив, ?(СтрокаДерева = Неопределено, Форма.ДеревоСпецификаций, СтрокаДерева));
	
КонецПроцедуры

// Сохраняет состояние дерева спецификации
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма
// 	Уровень - Число - уровень дерева
// 	МассивИндексов - Массив из Число - индексы на пути к элементу
// 	Дерево - ДеревоЗначений - дерево
Процедура СохранитьСостояниеУровняДерева(Форма, Уровень, МассивИндексов, Дерево)
	
	Элементы = Форма.Элементы;
	
	СтрокиДерева = Дерево.ПолучитьЭлементы();
	Для Индекс = 0 По СтрокиДерева.Количество() - 1 Цикл
		
		МассивИндексов.Вставить(0,Индекс);
		Строка = СтрокиДерева[Индекс];
		Идентификатор = Строка.ПолучитьИдентификатор();
		
		Развернут = Элементы.ДеревоСпецификаций.Развернут(Идентификатор);
		Текущий   = Элементы.ДеревоСпецификаций.ТекущаяСтрока = Идентификатор;
		Если Развернут ИЛИ Текущий Тогда
			ДанныеСтроки = ОписаниеЭлементаСостоянияУровняДерева();
			ДанныеСтроки.Уровень         = Уровень;
			ДанныеСтроки.ПутьКЭлементу   = СтрСоединить(МассивИндексов,"-");
			ДанныеСтроки.ВидСтроки       = Строка.ВидСтроки;
			ДанныеСтроки.Номенклатура    = Строка.Номенклатура;
			ДанныеСтроки.Характеристика  = Строка.Характеристика;
			ДанныеСтроки.Развернут       = Развернут;
			ДанныеСтроки.Текущий         = Текущий;
			Форма.РазвернутыеУровниДерева.Вставить("_"+Формат(Форма.РазвернутыеУровниДерева.Количество(),"ЧН=0; ЧГ="), ДанныеСтроки);
			СохранитьСостояниеУровняДерева(Форма, Уровень+1, МассивИндексов, Строка);
		КонецЕсли;
		МассивИндексов.Удалить(0);
	КонецЦикла;
	
КонецПроцедуры

// Восстанавливает состояние уровня дерева
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма
// 	Уровень - Число - уровень дерева
// 	МассивИндексов - Массив из Число - индексы на пути к элементу
// 	Дерево - ДеревоЗначений - дерево
Процедура ВосстановитьСостояниеУровняДерева(Форма, Уровень, МассивИндексов, Дерево)
	
	Элементы = Форма.Элементы;
	
	СтрокиДерева = Дерево.ПолучитьЭлементы();
	Для Индекс = 0 По СтрокиДерева.Количество() - 1 Цикл
		
		МассивИндексов.Вставить(0,Индекс);
		Строка = СтрокиДерева[Индекс];
		
		ПутьКЭлементу = СтрСоединить(МассивИндексов,"-");
		Для каждого КлючИЗначение Из Форма.РазвернутыеУровниДерева Цикл
			ДанныеСтроки = КлючИЗначение.Значение; // см. ОписаниеЭлементаСостоянияУровняДерева
			Если Уровень = ДанныеСтроки.Уровень
				И ПутьКЭлементу = ДанныеСтроки.ПутьКЭлементу
				И Строка.ВидСтроки = ДанныеСтроки.ВидСтроки
				И Строка.Номенклатура = ДанныеСтроки.Номенклатура
				И Строка.Характеристика = ДанныеСтроки.Характеристика
			Тогда
				Идентификатор = Строка.ПолучитьИдентификатор();
				Если ДанныеСтроки.Развернут Тогда
					Элементы.ДеревоСпецификаций.Развернуть(Идентификатор, Ложь);
				КонецЕсли;
				Если ДанныеСтроки.Текущий Тогда
					Элементы.ДеревоСпецификаций.ТекущаяСтрока = Идентификатор;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		ВосстановитьСостояниеУровняДерева(Форма, Уровень+1, МассивИндексов, Строка);
		МассивИндексов.Удалить(0);
	КонецЦикла;
	
КонецПроцедуры

// Конструктор элемента состояния уровня дерева
// 
// Возвращаемое значение:
// 	Структура - из:
// * Уровень - Число - уровень дерева
// * ПутьКЭлементу - Строка - путь к элементу
// * ВидСтроки - ПеречислениеСсылка.ВидыСтрокДереваСпецификаций - вид строки дерева
// * Номенклатура - СправочникСсылка.Номенклатура - номенклатура
// * Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - характеристика
// * Развернут - Булево - признак что строка развернута
// * Текущий - Булево - признак что строка является текущей
Функция ОписаниеЭлементаСостоянияУровняДерева()
	
	Результат = Новый Структура;
	
	Результат.Вставить("Уровень");
	Результат.Вставить("ПутьКЭлементу");
	Результат.Вставить("ВидСтроки");
	Результат.Вставить("Номенклатура");
	Результат.Вставить("Характеристика");
	
	Результат.Вставить("Развернут");
	Результат.Вставить("Текущий");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

//++ НЕ УТКА

#Область НаборыМатериаловИРабот

// Очищает служебные реквизиты в строке табличной части
// 
// Параметры:
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - данные строки
Процедура ОчиститьРеквизитыНабораВСтроке(ДанныеСтроки) Экспорт
	
	ДанныеСтроки.КлючСвязиНабор = Неопределено;
	ДанныеСтроки.ВходитВНабор    = Ложь;
	
КонецПроцедуры

// Определяет, есть ли в заданной табличной части строки, являющиеся комплектующими набора
// 
// Параметры:
//  Объект - ДокументОбъект.ЭтапПроизводства2_2
//  ИдентификаторыСтрок - Массив из Число - проверяемые строки
//  ИсточникМатериалов - Строка - Имя табличной части
// 
// Возвращаемое значение:
//  Булево
Функция ЕстьСтрокиВходящиеВНабор(Объект, ИдентификаторыСтрок, ИсточникМатериалов = "ОбеспечениеМатериаламиИРаботами") Экспорт
	
	ЕстьСтрокиВходящиеВНабор = Ложь;
	
	Для каждого Идентификатор Из ИдентификаторыСтрок Цикл
		ДанныеСтроки = Объект[ИсточникМатериалов].НайтиПоИдентификатору(Идентификатор);
		Если ЗначениеЗаполнено(ДанныеСтроки.КлючСвязиНабор) Тогда
			ЕстьСтрокиВходящиеВНабор = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьСтрокиВходящиеВНабор;
	
КонецФункции

#КонецОбласти

//-- НЕ УТКА

#КонецОбласти